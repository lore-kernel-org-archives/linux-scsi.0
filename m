Return-Path: <SRS0=ycLx=5L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 337AFC43331
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 01:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0000620719
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 01:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbgCZBoP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 21:44:15 -0400
Received: from smtp.infotech.no ([82.134.31.41]:40889 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727575AbgCZBoP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Mar 2020 21:44:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 2337B20418E;
        Thu, 26 Mar 2020 02:44:12 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id L7oZ6p0MtNvF; Thu, 26 Mar 2020 02:44:05 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 20089204179;
        Thu, 26 Mar 2020 02:44:04 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v2] scsi: core: Make MODE SENSE DBD a boolean
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <116e8e24-d442-6239-b401-dd3145f4e8e8@acm.org>
 <20200325222416.5094-1-martin.petersen@oracle.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <257ddb5a-87f3-9e27-8f9a-d647483528ab@interlog.com>
Date:   Wed, 25 Mar 2020 21:44:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200325222416.5094-1-martin.petersen@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-25 6:24 p.m., Martin K. Petersen wrote:
> The scsi_mode_sense() function has an argument called 'dbd' but
> confusingly this is used to specify the entire second byte of the CDB
> and not just the DBD bit.
> 
> Several callers assumed that 'dbd' was a flag and passed in a value of
> 1 instead of the required 8 to disable fetching block descriptors.
> The invalid value of 1 was subsequently masked off by the function and
> was not actually passed on to the device.
> 
> Turn the 'dbd' argument into a boolean and fix all callers.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> ---
> 
> v2:	Fix conversion error spotted by Bart
> ---
>   drivers/scsi/scsi_lib.c           |  7 ++++---
>   drivers/scsi/scsi_transport_sas.c |  2 +-
>   drivers/scsi/sd.c                 | 14 +++++++-------
>   drivers/scsi/sr.c                 |  2 +-
>   include/scsi/scsi_device.h        |  2 +-
>   5 files changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 47835c4b4ee0..acbbdb022a45 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2085,7 +2085,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
>    *	issued) if successful.
>    */
>   int
> -scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
> +scsi_mode_sense(struct scsi_device *sdev, bool dbd, int modepage,
>   		  unsigned char *buffer, int len, int timeout, int retries,
>   		  struct scsi_mode_data *data, struct scsi_sense_hdr *sshdr)
>   {
> @@ -2098,8 +2098,9 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
>   	memset(data, 0, sizeof(*data));
>   	memset(&cmd[0], 0, 12);
>   
> -	dbd = sdev->set_dbd_for_ms ? 8 : dbd;
> -	cmd[1] = dbd & 0x18;	/* allows DBD and LLBA bits */
> +	dbd = sdev->set_dbd_for_ms ? true : dbd;
> +	if (dbd)
> +		cmd[1] = 1 << 3; /* DBD bit */
>   	cmd[2] = modepage;
>   
>   	/* caller might not be interested in sense, but we need it */

I think scsi_mode_sense() needs looking at. It says this in its header:

*      @dbd:   set if mode sense will allow block descriptors to be returned

which is a worry when you consider that DBD bit means "DISABLE block
descriptors" [spc6r01.pdf chapter 6.14.1]. If the caller wants block
descriptors (i.e. dbd=0 (or false)) then they really should set the
LLBA bit or they will be truncating any LBAs (in the returned block
descriptors) greater than 2**32-1 to the lower 32 bits. However only
the MODE SENSE(10) command has the LLBA bit. So if MODE SENSE(10)
fails and you leave the LLBA bit set and switch to MODE SENSE(6) then
the device server is within its rights to say: WTF is bit 4 in
byte 1 set? Hence ==> illegal request.

Assuming MODE SENSE(10) is supported and DBD=0, then setting
the LLBA bit in the cdb should be okay, because the caller should be
looking at the LONGLBA bit in the "mode parameter header(10)"
[chapter 7.5.6 in the same document] that tells them how to decode
the returned block descriptors.
If MODE SENSE(10) is not supported and the code falls back to
MODE SENSE(6) then a heuristic is needed by the caller to work out
how to decode the response. And that comment about the return
value doesn't help.

That function is just badly designed and does not allow for subpages.
Can it be thrown out?
The caller should be told which MODE SENSE command worked (if any)
and be given the whole data-in buffer. Then another function that
calls the the first one and implies DBD=1 could return the part of
the data-in buffer that contains one or more mode pages. Plural
because modepage could be 0x3f and/or subpage could be 0xff which
are wildcards.

Suggestion:

int
scsi_mode_sense10_6(struct scsi_device *sdev, bool dbd, int modepage,
		int subpage, u8 *b, int len, int timeout, int retries,
                 bool *did_ms10, bool *truncated,
		struct scsi_mode_data *data, struct scsi_sense_hdr *sshdr);

int
scsi_get_mode_pages(struct scsi_device *sdev, int modepage, int subpage,
		u8 *b, int len, bool *truncated);

Doug Gilbert

> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 182fd25c7c43..0547ccd81e84 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -1234,7 +1234,7 @@ int sas_read_port_mode_page(struct scsi_device *sdev)
>   	if (!buffer)
>   		return -ENOMEM;
>   
> -	res = scsi_mode_sense(sdev, 1, 0x19, buffer, BUF_SIZE, 30*HZ, 3,
> +	res = scsi_mode_sense(sdev, true, 0x19, buffer, BUF_SIZE, 30*HZ, 3,
>   			      &mode_data, NULL);
>   
>   	error = -EINVAL;
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 8ca9299ffd36..7f7b0ba8c3d8 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -193,7 +193,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
>   		return count;
>   	}
>   
> -	if (scsi_mode_sense(sdp, 0x08, 8, buffer, sizeof(buffer), SD_TIMEOUT,
> +	if (scsi_mode_sense(sdp, true, 8, buffer, sizeof(buffer), SD_TIMEOUT,
>   			    SD_MAX_RETRIES, &data, NULL))
>   		return -EINVAL;
>   	len = min_t(size_t, sizeof(buffer), data.length - data.header_length -
> @@ -2561,7 +2561,7 @@ sd_print_capacity(struct scsi_disk *sdkp,
>   
>   /* called with buffer of length 512 */
>   static inline int
> -sd_do_mode_sense(struct scsi_device *sdp, int dbd, int modepage,
> +sd_do_mode_sense(struct scsi_device *sdp, bool dbd, int modepage,
>   		 unsigned char *buffer, int len, struct scsi_mode_data *data,
>   		 struct scsi_sense_hdr *sshdr)
>   {
> @@ -2639,7 +2639,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
>   	int len = 0, res;
>   	struct scsi_device *sdp = sdkp->device;
>   
> -	int dbd;
> +	bool dbd;
>   	int modepage;
>   	int first_len;
>   	struct scsi_mode_data data;
> @@ -2662,14 +2662,14 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
>   			modepage = 0x3F;
>   			if (sdp->use_192_bytes_for_3f)
>   				first_len = 192;
> -			dbd = 0;
> +			dbd = false;
>   		}
>   	} else if (sdp->type == TYPE_RBC) {
>   		modepage = 6;
> -		dbd = 8;
> +		dbd = true;
>   	} else {
>   		modepage = 8;
> -		dbd = 0;
> +		dbd = false;
>   	}
>   
>   	/* cautiously ask */
> @@ -2823,7 +2823,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
>   	if (sdkp->protection_type == 0)
>   		return;
>   
> -	res = scsi_mode_sense(sdp, 1, 0x0a, buffer, 36, SD_TIMEOUT,
> +	res = scsi_mode_sense(sdp, true, 0x0a, buffer, 36, SD_TIMEOUT,
>   			      SD_MAX_RETRIES, &data, &sshdr);
>   
>   	if (!scsi_status_is_good(res) || !data.header_length ||
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index fe0e1c721a99..f31a946b7cd5 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -936,7 +936,7 @@ static void get_capabilities(struct scsi_cd *cd)
>   	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
>   
>   	/* ask for mode page 0x2a */
> -	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, ms_len,
> +	rc = scsi_mode_sense(cd->device, false, 0x2a, buffer, ms_len,
>   			     SR_TIMEOUT, 3, &data, NULL);
>   
>   	if (!scsi_status_is_good(rc) || data.length > ms_len ||
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index c3cba2aaf934..853082b7bcf6 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -397,7 +397,7 @@ extern int scsi_track_queue_full(struct scsi_device *, int);
>   
>   extern int scsi_set_medium_removal(struct scsi_device *, char);
>   
> -extern int scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
> +extern int scsi_mode_sense(struct scsi_device *sdev, bool dbd, int modepage,
>   			   unsigned char *buffer, int len, int timeout,
>   			   int retries, struct scsi_mode_data *data,
>   			   struct scsi_sense_hdr *);
> 

