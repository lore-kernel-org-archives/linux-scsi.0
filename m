From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [RFC] libata-scsi: introducing SANITIZE translation
Date: Sat, 9 Jul 2016 00:20:24 +0800
Message-ID: <CAGnHSE=8HEZ8AnDGjdOAhaA8f117GdbZZNhbQQOCYYM1b-8PvQ@mail.gmail.com>
References: <577e843e.0a86620a.59167.ffffb899@mx.google.com> <1467910054.2322.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1467910054.2322.7.camel@HansenPartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Tejun Heo <tj@kernel.org>, martin.petersen@oracle.com, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

To be honest, that sounds like FUD to me.

The exact reason why this can "safely" be introduced to the SATL is
that, it is a "one-shot" command that would only be triggered by the
user through a user space utility. It's nothing like TRIM that would
be triggered by the filesystem layer or so "from time to time", which
might cost users "unexpected" data loss. It is also nothing like
SECURE ERASE (which vendors had to abuse to provide equivalence of
BLOCK ERASE and CRYPTOGRAPHIC ERASE for SSDs and drives that does
hardware encryption) that requires the drive to be locked before you
can issue an erase command.

Certainly you can expect users to pack an ATA PASS-THROUGH command
themselves and issued it with sg_raw or so, or hdparm to be patched to
support the full feature set (including the "optional"
FREEZE/ANTIFREEZE sub-feature), but I don't see how these would be
reasons that the translation should not be introduced to the kernel,
so that we can make good use of its existing SATL infrastructure and
sg_sanitize.

Whether it is "secure" enough to use the implementation would be the
user's call. To be frank, saying that implementing it in the "SAT-way"
would make it untrustable doesn't make any sense to me, especially
when the way the feature set works is considered.

On 8 July 2016 at 00:47, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2016-07-08 at 00:32 +0800, tom.ty89@gmail.com wrote:
>> From: Tom Yan <tom.ty89@gmail.com>
>>
>> With this patch, users can make use of the SANITIZE DEVICE feature
>> set through utility like sg_sanitize.
>>
>> Support for BLOCK ERASE, CRYPTOGRAPHIC ERASE and EXIT FAILURE MODE
>> has been implemented. Support for OVERWRITE that involves a
>> parameter list has been left out for now.
>>
>> Further support for command with IMMED bit set to zero, REQUEST
>> SENSE translation for user-space status polling, and support
>> checking in IDENTIFY DEVICE data log (return proper sense data
>> when designated method is not supported) should be implemented
>> in the future as well.
>>
>> `sg_sanitize -e -B|-C|-F /dev/sdX` should work fine with this.
>
> Why on earth would you want to do this?  If your intent is to sanitise
> the disk using a cryptographic erase you presumably have a real
> security need for doing it and, knowing what goes into most SAT layers,
> I'd not really trust any SAT for this operation, so for an underlying
> SATA device I'd use ATA_16 to send a real ACS-2 SANITIZE command.
>
> Just as a general note about our SAT layer: Adding little used features
> is an invitation to bloat it with buggy implementations which makes it
> harder to understand and bug prone for odd and unlikely use cases,
> which then take ages to diagnose and track down.  The only things which
> should be in the SAT is what the Linux SCSI subsystem would actually
> use.  For everything else, if the user cares enough, they'll send down
> an encapsulated ATA command.
>
> James
>
>
