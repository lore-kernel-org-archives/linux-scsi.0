From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/4] scsi: aacraid: remove AAC_STAT_GOOD define
Date: Fri, 6 Jul 2018 10:04:47 +0200
Message-ID: <20180706080447.2u3iptpnvmso6ncc@linux-x5ow.site>
References: <20180705110140.19545-1-jthumshirn@suse.de>
 <20180705110140.19545-2-jthumshirn@suse.de>
 <babfea1746aaca57109f84bff674dda635a76e29.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <babfea1746aaca57109f84bff674dda635a76e29.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "RaghavaAditya.Renukunta@microsemi.com" <RaghavaAditya.Renukunta@microsemi.com>, "david.carroll@microsemi.com" <david.carroll@microsemi.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 05, 2018 at 05:24:23PM +0000, Bart Van Assche wrote:
> On Thu, 2018-07-05 at 13:01 +0200, Johannes Thumshirn wrote:
> >  		if (((aac_cache & 6) == 6) && dev->cache_protected) {
> > -			scsicmd->result = AAC_STAT_GOOD;
> > +			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
> > +					  SAM_STAT_GOOD;
> 
> Does AAC_STAT_GOOD really have to be expanded in full multiple times?
> Have you considered to replace AAC_STAT_GOOD by the numerical constant
> 0 instead?

This won't work anymore once we start splitting ->result into 4
unrelated enums. That's why I prefer this way.

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
