From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/1] aacraid: SCSI dma mapping failure case handling
Date: Wed, 17 Oct 2012 13:16:35 +0200
Message-ID: <507E9393.4080909@redhat.com>
References: <1350490547-1509-1-git-send-email-Mahesh_Rajashekhara@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300Ab2JQLQn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2012 07:16:43 -0400
In-Reply-To: <1350490547-1509-1-git-send-email-Mahesh_Rajashekhara@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh_Rajashekhara@pmc-sierra.com>
Cc: JBottomley@Parallels.com, linux-scsi@vger.kernel.org, aacraid@pmc-sierra.com, Achim_Leubner@pmc-sierra.com, Tony_Ruiz@pmc-sierra.com

On 10/17/2012 06:15 PM, Mahesh Rajashekhara wrote:
> From: Mahesh Rajashekhara <Mahesh_Rajashekhara@pmc-sierra.com>
>
> Hi Tomas,
>
> Thanks for the correction.
>
> I have changed 'ret' is of type 'long' now.

I think that more than that is needed, all the aac_build_...
functions prototypes are declared as of type 'unsigned long'
and they return 'byte_count' which again is 'unsigned'.

>
> Signed-off-by: Mahesh Rajashekhara <Mahesh_Rajashekhara@pmc-sierra.com>
> ---
>  drivers/scsi/aacraid/aachba.c  |   87 +++++++++++++++++++++++++++++----------
>  drivers/scsi/aacraid/aacraid.h |    2 +-
>  2 files changed, 65 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index d79457a..681434e 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -132,11 +132,13 @@ struct inquiry_data {
>   *              M O D U L E   G L O B A L S
>   */
>  
> -static unsigned long aac_build_sg(struct scsi_cmnd* scsicmd, struct sgmap* sgmap);
> -static unsigned long aac_build_sg64(struct scsi_cmnd* scsicmd, struct sgmap64* psg);
> -static unsigned long aac_build_sgraw(struct scsi_cmnd* scsicmd, struct sgmapraw* psg);
> -static unsigned long aac_build_sgraw2(struct scsi_cmnd *scsicmd, struct aac_raw_io2 *rio2, int sg_max);
> -static int aac_convert_sgraw2(struct aac_raw_io2 *rio2, int pages, int nseg, int nseg_new);
> +static long aac_build_sg(struct scsi_cmnd *scsicmd, struct sgmap *sgmap);
> +static long aac_build_sg64(struct scsi_cmnd *scsicmd, struct sgmap64 *psg);
> +static long aac_build_sgraw(struct scsi_cmnd *scsicmd, struct sgmapraw *psg);
> +static long aac_build_sgraw2(struct scsi_cmnd *scsicmd,
> +				struct aac_raw_io2 *rio2, int sg_max);
> +static int aac_convert_sgraw2(struct aac_raw_io2 *rio2,
> +				int pages, int nseg, int nseg_new);
>  static int aac_send_srb_fib(struct scsi_cmnd* scsicmd);
>  #ifdef AAC_DETAILED_STATUS_INFO
>  static char *aac_get_status_string(u32 status);
> @@ -971,6 +973,7 @@ static int aac_read_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
>  {
>  	struct aac_dev *dev = fib->dev;
>  	u16 fibsize, command;
> +	long ret;
>  
>  	aac_fib_init(fib);
>  	if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE2 && !dev->sync_mode) {
> @@ -982,7 +985,10 @@ static int aac_read_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
>  		readcmd2->byteCount = cpu_to_le32(count<<9);
>  		readcmd2->cid = cpu_to_le16(scmd_id(cmd));
>  		readcmd2->flags = cpu_to_le16(RIO2_IO_TYPE_READ);
> -		aac_build_sgraw2(cmd, readcmd2, dev->scsi_host_ptr->sg_tablesize);
> +		ret = aac_build_sgraw2(cmd, readcmd2,
> +				dev->scsi_host_ptr->sg_tablesize);
> +		if (ret < 0)
> +			return ret;
>  		command = ContainerRawIo2;
>  		fibsize = sizeof(struct aac_raw_io2) +
>  			((le32_to_cpu(readcmd2->sgeCnt)-1) * sizeof(struct sge_ieee1212));
> @@ -996,7 +1002,9 @@ static int aac_read_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
>  		readcmd->flags = cpu_to_le16(RIO_TYPE_READ);
>  		readcmd->bpTotal = 0;
>  		readcmd->bpComplete = 0;
> -		aac_build_sgraw(cmd, &readcmd->sg);
> +		ret = aac_build_sgraw(cmd, &readcmd->sg);
> +		if (ret < 0)
> +			return ret;
>  		command = ContainerRawIo;
>  		fibsize = sizeof(struct aac_raw_io) +
>  			((le32_to_cpu(readcmd->sg.count)-1) * sizeof(struct sgentryraw));
> @@ -1019,6 +1027,8 @@ static int aac_read_block64(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
>  {
>  	u16 fibsize;
>  	struct aac_read64 *readcmd;
> +	long ret;
> +
>  	aac_fib_init(fib);
>  	readcmd = (struct aac_read64 *) fib_data(fib);
>  	readcmd->command = cpu_to_le32(VM_CtHostRead64);
> @@ -1028,7 +1038,9 @@ static int aac_read_block64(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
>  	readcmd->pad   = 0;
>  	readcmd->flags = 0;
>  
> -	aac_build_sg64(cmd, &readcmd->sg);
> +	ret = aac_build_sg64(cmd, &readcmd->sg);
> +	if (ret < 0)
> +		return ret;
>  	fibsize = sizeof(struct aac_read64) +
>  		((le32_to_cpu(readcmd->sg.count) - 1) *
>  		 sizeof (struct sgentry64));
> @@ -1050,6 +1062,8 @@ static int aac_read_block(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u32
>  {
>  	u16 fibsize;
>  	struct aac_read *readcmd;
> +	long ret;
> +
>  	aac_fib_init(fib);
>  	readcmd = (struct aac_read *) fib_data(fib);
>  	readcmd->command = cpu_to_le32(VM_CtBlockRead);
> @@ -1057,7 +1071,9 @@ static int aac_read_block(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u32
>  	readcmd->block = cpu_to_le32((u32)(lba&0xffffffff));
>  	readcmd->count = cpu_to_le32(count * 512);
>  
> -	aac_build_sg(cmd, &readcmd->sg);
> +	ret = aac_build_sg(cmd, &readcmd->sg);
> +	if (ret < 0)
> +		return ret;
>  	fibsize = sizeof(struct aac_read) +
>  			((le32_to_cpu(readcmd->sg.count) - 1) *
>  			 sizeof (struct sgentry));
> @@ -1079,6 +1095,7 @@ static int aac_write_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
>  {
>  	struct aac_dev *dev = fib->dev;
>  	u16 fibsize, command;
> +	long ret;
>  
>  	aac_fib_init(fib);
>  	if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE2 && !dev->sync_mode) {
> @@ -1093,7 +1110,10 @@ static int aac_write_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
>  						   (((aac_cache & 5) != 5) || !fib->dev->cache_protected)) ?
>  			cpu_to_le16(RIO2_IO_TYPE_WRITE|RIO2_IO_SUREWRITE) :
>  			cpu_to_le16(RIO2_IO_TYPE_WRITE);
> -		aac_build_sgraw2(cmd, writecmd2, dev->scsi_host_ptr->sg_tablesize);
> +		ret = aac_build_sgraw2(cmd, writecmd2,
> +				dev->scsi_host_ptr->sg_tablesize);
> +		if (ret < 0)
> +			return ret;
>  		command = ContainerRawIo2;
>  		fibsize = sizeof(struct aac_raw_io2) +
>  			((le32_to_cpu(writecmd2->sgeCnt)-1) * sizeof(struct sge_ieee1212));
> @@ -1110,7 +1130,9 @@ static int aac_write_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
>  			cpu_to_le16(RIO_TYPE_WRITE);
>  		writecmd->bpTotal = 0;
>  		writecmd->bpComplete = 0;
> -		aac_build_sgraw(cmd, &writecmd->sg);
> +		ret = aac_build_sgraw(cmd, &writecmd->sg);
> +		if (ret < 0)
> +			return ret;
>  		command = ContainerRawIo;
>  		fibsize = sizeof(struct aac_raw_io) +
>  			((le32_to_cpu(writecmd->sg.count)-1) * sizeof (struct sgentryraw));
> @@ -1133,6 +1155,8 @@ static int aac_write_block64(struct fib * fib, struct scsi_cmnd * cmd, u64 lba,
>  {
>  	u16 fibsize;
>  	struct aac_write64 *writecmd;
> +	long ret;
> +
>  	aac_fib_init(fib);
>  	writecmd = (struct aac_write64 *) fib_data(fib);
>  	writecmd->command = cpu_to_le32(VM_CtHostWrite64);
> @@ -1142,7 +1166,9 @@ static int aac_write_block64(struct fib * fib, struct scsi_cmnd * cmd, u64 lba,
>  	writecmd->pad	= 0;
>  	writecmd->flags	= 0;
>  
> -	aac_build_sg64(cmd, &writecmd->sg);
> +	ret = aac_build_sg64(cmd, &writecmd->sg);
> +	if (ret < 0)
> +		return ret;
>  	fibsize = sizeof(struct aac_write64) +
>  		((le32_to_cpu(writecmd->sg.count) - 1) *
>  		 sizeof (struct sgentry64));
> @@ -1164,6 +1190,8 @@ static int aac_write_block(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
>  {
>  	u16 fibsize;
>  	struct aac_write *writecmd;
> +	long ret;
> +
>  	aac_fib_init(fib);
>  	writecmd = (struct aac_write *) fib_data(fib);
>  	writecmd->command = cpu_to_le32(VM_CtBlockWrite);
> @@ -1173,7 +1201,9 @@ static int aac_write_block(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
>  	writecmd->sg.count = cpu_to_le32(1);
>  	/* ->stable is not used - it did mean which type of write */
>  
> -	aac_build_sg(cmd, &writecmd->sg);
> +	ret = aac_build_sg(cmd, &writecmd->sg);
> +	if (ret < 0)
> +		return ret;
>  	fibsize = sizeof(struct aac_write) +
>  		((le32_to_cpu(writecmd->sg.count) - 1) *
>  		 sizeof (struct sgentry));
> @@ -1235,8 +1265,11 @@ static int aac_scsi_64(struct fib * fib, struct scsi_cmnd * cmd)
>  {
>  	u16 fibsize;
>  	struct aac_srb * srbcmd = aac_scsi_common(fib, cmd);
> +	long ret;
>  
> -	aac_build_sg64(cmd, (struct sgmap64*) &srbcmd->sg);
> +	ret = aac_build_sg64(cmd, (struct sgmap64 *) &srbcmd->sg);
> +	if (ret < 0)
> +		return ret;
>  	srbcmd->count = cpu_to_le32(scsi_bufflen(cmd));
>  
>  	memset(srbcmd->cdb, 0, sizeof(srbcmd->cdb));
> @@ -1263,8 +1296,11 @@ static int aac_scsi_32(struct fib * fib, struct scsi_cmnd * cmd)
>  {
>  	u16 fibsize;
>  	struct aac_srb * srbcmd = aac_scsi_common(fib, cmd);
> +	long ret;
>  
> -	aac_build_sg(cmd, (struct sgmap*)&srbcmd->sg);
> +	ret = aac_build_sg(cmd, (struct sgmap *)&srbcmd->sg);
> +	if (ret < 0)
> +		return ret;
>  	srbcmd->count = cpu_to_le32(scsi_bufflen(cmd));
>  
>  	memset(srbcmd->cdb, 0, sizeof(srbcmd->cdb));
> @@ -2870,7 +2906,7 @@ static int aac_send_srb_fib(struct scsi_cmnd* scsicmd)
>  	return -1;
>  }
>  
> -static unsigned long aac_build_sg(struct scsi_cmnd* scsicmd, struct sgmap* psg)
> +static long aac_build_sg(struct scsi_cmnd *scsicmd, struct sgmap *psg)
>  {
>  	struct aac_dev *dev;
>  	unsigned long byte_count = 0;
> @@ -2883,7 +2919,8 @@ static unsigned long aac_build_sg(struct scsi_cmnd* scsicmd, struct sgmap* psg)
>  	psg->sg[0].count = 0;
>  
>  	nseg = scsi_dma_map(scsicmd);
> -	BUG_ON(nseg < 0);
> +	if (nseg < 0)
> +		return nseg;
>  	if (nseg) {
>  		struct scatterlist *sg;
>  		int i;
> @@ -2912,7 +2949,7 @@ static unsigned long aac_build_sg(struct scsi_cmnd* scsicmd, struct sgmap* psg)
>  }
>  
>  
> -static unsigned long aac_build_sg64(struct scsi_cmnd* scsicmd, struct sgmap64* psg)
> +static long aac_build_sg64(struct scsi_cmnd *scsicmd, struct sgmap64 *psg)
>  {
>  	struct aac_dev *dev;
>  	unsigned long byte_count = 0;
> @@ -2927,7 +2964,8 @@ static unsigned long aac_build_sg64(struct scsi_cmnd* scsicmd, struct sgmap64* p
>  	psg->sg[0].count = 0;
>  
>  	nseg = scsi_dma_map(scsicmd);
> -	BUG_ON(nseg < 0);
> +	if (nseg < 0)
> +		return nseg;
>  	if (nseg) {
>  		struct scatterlist *sg;
>  		int i;
> @@ -2957,7 +2995,7 @@ static unsigned long aac_build_sg64(struct scsi_cmnd* scsicmd, struct sgmap64* p
>  	return byte_count;
>  }
>  
> -static unsigned long aac_build_sgraw(struct scsi_cmnd* scsicmd, struct sgmapraw* psg)
> +static long aac_build_sgraw(struct scsi_cmnd *scsicmd, struct sgmapraw *psg)
>  {
>  	unsigned long byte_count = 0;
>  	int nseg;
> @@ -2972,7 +3010,8 @@ static unsigned long aac_build_sgraw(struct scsi_cmnd* scsicmd, struct sgmapraw*
>  	psg->sg[0].flags = 0;
>  
>  	nseg = scsi_dma_map(scsicmd);
> -	BUG_ON(nseg < 0);
> +	if (nseg < 0)
> +		return nseg;
>  	if (nseg) {
>  		struct scatterlist *sg;
>  		int i;
> @@ -3005,13 +3044,15 @@ static unsigned long aac_build_sgraw(struct scsi_cmnd* scsicmd, struct sgmapraw*
>  	return byte_count;
>  }
>  
> -static unsigned long aac_build_sgraw2(struct scsi_cmnd *scsicmd, struct aac_raw_io2 *rio2, int sg_max)
> +static long aac_build_sgraw2(struct scsi_cmnd *scsicmd,
> +				struct aac_raw_io2 *rio2, int sg_max)
>  {
>  	unsigned long byte_count = 0;
>  	int nseg;
>  
>  	nseg = scsi_dma_map(scsicmd);
> -	BUG_ON(nseg < 0);
> +	if (nseg < 0)
> +		return nseg;
>  	if (nseg) {
>  		struct scatterlist *sg;
>  		int i, conformable = 0;
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> index 9e933a8..742f5d7 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -12,7 +12,7 @@
>   *----------------------------------------------------------------------------*/
>  
>  #ifndef AAC_DRIVER_BUILD
> -# define AAC_DRIVER_BUILD 29800
> +# define AAC_DRIVER_BUILD 29801
>  # define AAC_DRIVER_BRANCH "-ms"
>  #endif
>  #define MAXIMUM_NUM_CONTAINERS	32

