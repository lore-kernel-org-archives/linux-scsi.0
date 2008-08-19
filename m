From: "Gwendal Grignou" <gwendal@google.com>
Subject: Re: [PATCH #upstream-fixes] libata: Add transport class for libata
Date: Tue, 19 Aug 2008 11:14:17 -0700
Message-ID: <e7510f760808191114w614403eej2fd3ae4fb0176050@mail.gmail.com>
References: <e7510f760808182131q1bd3aa4bp694ebff75b612995@mail.gmail.com>
	 <48AAAFAC.9050502@s5r6.in-berlin.de>
	 <20080819122738.GC21854@parisc-linux.org>
	 <48AAC7B0.9060107@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <48AAC7B0.9060107@s5r6.in-berlin.de>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Matthew Wilcox <matthew@wil.cx>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Stefan,

My mistake. I started from scsi_transport_sas.c code already present
in the kernel; I forgot to remove the copyright notice. I changed the
copyright notice.

About Documentation/ABI, I did not found any information about
existing transport classes [sas,fc,spi,iscsi,...]. I added on for
libata transport class. I send a new patch shortly.

Thanks,

Gwendal.

On Tue, Aug 19, 2008 at 6:16 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Matthew Wilcox wrote:
>> I think a more important question is ... this is coming from a Google
>> address, but has a Copyright Dell on it.  Where's the sign-off chain for
>> this?  Who's the author really?
>
> Indeed, this needs to be clarified.
>
>>> Gwendal Grignou wrote:
>>>> +#define SETUP_TEMPLATE(attrb, field, perm, test)                   \
>>>> +   i->private_##attrb[count] = dev_attr_##field;                   \
>>>> +   i->private_##attrb[count].attr.mode = perm;                     \
>>>> +   i->attrb[count] = &i->private_##attrb[count];                   \
>>>> +   if (test)                                                       \
>>>> +           count++
> ...
>>>> +#define SETUP_PORT_ATTRIBUTE(field)                                        \
>>>> +   SETUP_TEMPLATE(port_attrs, field, S_IRUGO, 1)
> ...
>>>> +   count = 0;
>>>> +   SETUP_PORT_ATTRIBUTE(nr_pmp_links);
>>>> +   SETUP_PORT_ATTRIBUTE(idle_irq);
>>>> +   BUG_ON(count > ATA_PORT_ATTRS);
>>>> +   i->port_attrs[count] = NULL;
>
> I understand that such preprocessor games are hard to avoid in code like
> sysfs attribute setup.  I have nothing better to suggest, but they are
> ugly nevertheless, and may amount to bloat.
>
> Anyway; the BUG_ON there should probably be a BUILD_BUG_ON.
> --
> Stefan Richter
> -=====-==--- =--- =--==
> http://arcgraph.de/sr/
>
