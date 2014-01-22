From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 12/17] target/file: Add DIF protection init/format
 support
Date: Wed, 22 Jan 2014 14:13:19 -0800
Message-ID: <1390428799.5567.972.camel@haakon3.risingtidesystems.com>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>
	 <1390099480-29013-13-git-send-email-nab@daterainc.com>
	 <52DBC592.6010405@dev.mellanox.co.il>
	 <1390343288.5567.782.camel@haakon3.risingtidesystems.com>
	 <52DF9989.5050008@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <52DF9989.5050008@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-01-22 at 12:12 +0200, Sagi Grimberg wrote:
> On 1/22/2014 12:28 AM, Nicholas A. Bellinger wrote:
> > On Sun, 2014-01-19 at 14:31 +0200, Sagi Grimberg wrote:
> >> On 1/19/2014 4:44 AM, Nicholas A. Bellinger wrote:
> >>> From: Nicholas Bellinger <nab@linux-iscsi.org>
> >>>
> >>> This patch adds support for DIF protection init/format support into
> >>> the FILEIO backend.
> >>>
> >>> It involves using a seperate $FILE.protection for storing PI that is
> >>> opened via fd_init_prot() using the common pi_prot_type attribute.
> >>> The actual formatting of the protection is done via fd_format_prot()
> >>> using the common pi_prot_format attribute, that will populate the
> >>> initial PI data based upon the currently configured pi_prot_type.
> >>>
> >>> Based on original FILEIO code from Sagi.
> >> Nice! see comments below...
> >>

<SNIP>

> >>> +static void fd_init_format_buf(struct se_device *dev, unsigned char *buf,
> >>> +			       u32 unit_size, u32 *ref_tag, u16 app_tag,
> >>> +			       bool inc_reftag)
> >>> +{
> >>> +	unsigned char *p = buf;
> >>> +	int i;
> >>> +
> >>> +	for (i = 0; i < unit_size; i += dev->prot_length) {
> >>> +		*((u16 *)&p[0]) = 0xffff;
> >>> +		*((__be16 *)&p[2]) = cpu_to_be16(app_tag);
> >>> +		*((__be32 *)&p[4]) = cpu_to_be32(*ref_tag);
> >>> +
> >>> +		if (inc_reftag)
> >>> +			(*ref_tag)++;
> >>> +
> >>> +		p += dev->prot_length;
> >>> +	}
> >>> +}
> >>> +
> >>> +static int fd_format_prot(struct se_device *dev)
> >>> +{
> >>> +	struct fd_dev *fd_dev = FD_DEV(dev);
> >>> +	struct file *prot_fd = fd_dev->fd_prot_file;
> >>> +	sector_t prot_length, prot;
> >>> +	unsigned char *buf;
> >>> +	loff_t pos = 0;
> >>> +	u32 ref_tag = 0;
> >>> +	int unit_size = FDBD_FORMAT_UNIT_SIZE * dev->dev_attrib.block_size;
> >>> +	int rc, ret = 0, size, len;
> >>> +	bool inc_reftag = false;
> >>> +
> >>> +	if (!dev->dev_attrib.pi_prot_type) {
> >>> +		pr_err("Unable to format_prot while pi_prot_type == 0\n");
> >>> +		return -ENODEV;
> >>> +	}
> >>> +	if (!prot_fd) {
> >>> +		pr_err("Unable to locate fd_dev->fd_prot_file\n");
> >>> +		return -ENODEV;
> >>> +	}
> >>> +
> >>> +	switch (dev->dev_attrib.pi_prot_type) {
> >> redundant - see below.
> >>> +	case TARGET_DIF_TYPE3_PROT:
> >>> +		ref_tag = 0xffffffff;
> >>> +		break;
> >>> +	case TARGET_DIF_TYPE2_PROT:
> >>> +	case TARGET_DIF_TYPE1_PROT:
> >>> +		inc_reftag = true;
> >>> +		break;
> >>> +	default:
> >>> +		break;
> >>> +	}
> >>> +
> >>> +	buf = vzalloc(unit_size);
> >>> +	if (!buf) {
> >>> +		pr_err("Unable to allocate FILEIO prot buf\n");
> >>> +		return -ENOMEM;
> >>> +	}
> >>> +
> >>> +	prot_length = (dev->transport->get_blocks(dev) + 1) * dev->prot_length;
> >>> +	size = prot_length;
> >>> +
> >>> +	pr_debug("Using FILEIO prot_length: %llu\n",
> >>> +		 (unsigned long long)prot_length);
> >>> +
> >>> +	for (prot = 0; prot < prot_length; prot += unit_size) {
> >>> +
> >>> +		fd_init_format_buf(dev, buf, unit_size, &ref_tag, 0xffff,
> >>> +				   inc_reftag);
> >> I didn't send you my latest patches (my fault...).T10-PI format should
> >> only place
> >> escape values throughout the protection file (fill it with 0xff). so I
> >> guess in this case
> >> fd_init_formast_buf() boils down to memset(buf, 0xff, unit_size) once
> >> before the loop
> >> and just loop until prot_length writing buf, no need to address
> >> apptag/reftag...
> > Yeah, was thinking about just formatting with escape values as mentioned
> > above, but thought it might be useful to keep around for pre-populating
> > values apptag + reftag values for testing purposes.
> >
> > --nab
> >
> 
> OK, but maybe it is better to do that under some debug configuration 
> rather then always do that.
> 

With the apptag escape in place from the format the host is going to
ignore the other areas, so this shouldn't really matter.

If it turns out to be a issue, we can just drop this code later.

--nab
