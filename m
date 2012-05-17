From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/6] qla4xxx: Capture minidump for ISP82XX on firmware
 failure
Date: Thu, 17 May 2012 10:12:49 +0100
Message-ID: <1337245969.30498.4.camel@dabdike.int.hansenpartnership.com>
References: <1335245557-17169-1-git-send-email-vikas.chaudhary@qlogic.com>
	 <1335245557-17169-6-git-send-email-vikas.chaudhary@qlogic.com>
	 <4F9AC3BB.2050708@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59819 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761404Ab2EQJMy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 May 2012 05:12:54 -0400
In-Reply-To: <4F9AC3BB.2050708@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: vikas.chaudhary@qlogic.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>, Shyam Sundar <shyam.sundar@qlogic.com>

On Fri, 2012-04-27 at 11:05 -0500, Mike Christie wrote:
> On 04/24/2012 12:32 AM, vikas.chaudhary@qlogic.com wrote:
> > +
> > +static ssize_t
> > +qla4_8xxx_sysfs_write_fw_dump(struct file *filep, struct kobject *kobj,
> > +			      struct bin_attribute *ba, char *buf, loff_t off,
> > +			      size_t count)
> > +{
> > +	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
> > +					       struct device, kobj)));
> > +	uint32_t dev_state;
> > +	int reading;
> > +
> > +	if (!is_qla8022(ha))
> > +		return -EINVAL;
> > +
> > +	if (off != 0)
> > +		return 0;
> > +
> > +	reading = simple_strtol(buf, NULL, 10);
> 
> I think we are supposed to be using kstrtol now.

We are.  Checkpatch even warns about this, please fix.

Thanks,

James


