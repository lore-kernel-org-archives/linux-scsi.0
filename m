From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 1/3] megaraid : use dev_printk when possible
Date: Mon, 1 Jun 2015 11:53:33 -0500
Message-ID: <CAErSpo6z9xZx59PcZWUH5wqGc9E89gpjQ+_tU3t2wv-24CzCDA@mail.gmail.com>
References: <20150601153240.23309.73917.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <20150601154003.23309.70647.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <1433175024.4861.11.camel@perches.com> <CAErSpo7E85pFOj2FC8BRcbXrvWa3AMTTV2dhW1d=w5BX+POKVA@mail.gmail.com>
 <1433177040.4861.25.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433177040.4861.25.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 1, 2015 at 11:44 AM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2015-06-01 at 11:40 -0500, Bjorn Helgaas wrote:
>> On Mon, Jun 1, 2015 at 11:10 AM, Joe Perches <joe@perches.com> wrote:
>> > On Mon, 2015-06-01 at 10:40 -0500, Bjorn Helgaas wrote:
>> >> Use dev_printk() when possible to make messages more useful.
>> > []
>> >> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
>> > []
>> >> @@ -268,7 +268,7 @@ mega_query_adapter(adapter_t *adapter)
>> >>               raw_mbox[2] = NC_SUBOP_PRODUCT_INFO;    /* i.e. 0x0E */
>> >>
>> >>               if ((retval = issue_scb_block(adapter, raw_mbox)))
>> >> -                     printk(KERN_WARNING
>> >> +                     dev_warn(&adapter->dev->dev,
>> >>                       "megaraid: Product_info cmd failed with error: %d\n",
>> >>                               retval);
>> >
>> > Wouldn't these be a bit redundant with a "megaraid: " prefix now?
>> > Perhaps it'd be nicer to realign arguments too.
>>
>> Yes, you're right.  I took out most of the "megaraid: " prefixes, but
>> I missed a few.
>>
>> I tried not to realign things too much because it's hard to know where
>> to stop, and I don't want to spend a week on this.
>
> ;)  I try to realign all modified statements.

That's probably a reasonable approach.  But it can also lead to
inconsistent indentation in the file, e.g., printk args indented
differently from args to other functions, which I don't like either.

Bjorn
