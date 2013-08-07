From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH 3/8] [SCSI] dc395x: use NULL instead of 0
Date: Wed, 07 Aug 2013 12:14:58 +0200
Message-ID: <1375870498.1747.3.camel@linux-fkkt.site>
References: <001301ce9321$f2157760$d6406620$@samsung.com>
	 <1375858203.1359.1.camel@linux-fkkt.site>
	 <002f01ce933b$96ebc370$c4c34a50$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:35670 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379Ab3HGKPC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2013 06:15:02 -0400
In-Reply-To: <002f01ce933b$96ebc370$c4c34a50$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jingoo Han <jg1.han@samsung.com>
Cc: 'James Bottomley' <JBottomley@Parallels.com>, 'Ali Akcaagac' <aliakc@web.de>, 'Jamie Lenehan' <lenehan@twibble.org>, dc395x@twibble.org, 'James Bottomley' <jejb@kernel.org>, linux-scsi@vger.kernel.org

On Wed, 2013-08-07 at 15:58 +0900, Jingoo Han wrote:
> On Wednesday, August 07, 2013 3:50 PM, Oliver Neukum wrote:
> > On Wed, 2013-08-07 at 12:55 +0900, Jingoo Han wrote:
> > 
> > > @@ -4183,15 +4183,17 @@ static void check_eeprom(struct NvRamType *eeprom, unsigned long io_port)
> > >  		 */
> > >  		dprintkl(KERN_WARNING,
> > >  			"EEProm checksum error: using default values and options.\n");
> > > -		eeprom->sub_vendor_id[0] = (u8)PCI_VENDOR_ID_TEKRAM;
> > > +		eeprom->sub_vendor_id[0] = (u8)(PCI_VENDOR_ID_TEKRAM & 0xff);
> > 
> > Hi,
> > 
> > if you are fixing these issues please use the proper macros for
> > conversion of endianness.
> 
> Sorry, I cannot understand exactly what you mean. :(
> Would you please let me know which macros can be used?

In this case constant_cpu_to_le16() would be the macro you want.
Have a look at include/uapi/linux/byteorder/

	Regards
		Oliver



