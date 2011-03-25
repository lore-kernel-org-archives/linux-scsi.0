From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
 initial merge
Date: Fri, 25 Mar 2011 12:31:40 +0100
Message-ID: <AANLkTik2UxAO3uZ8r1U0bqYVX+0zHGUAd8uuiPzVQq57@mail.gmail.com>
References: <1300916254.18039.87.camel@haakon2.linux-iscsi.org>
 <20110324074600L.fujita.tomonori@lab.ntt.co.jp> <1300922917.18039.147.camel@haakon2.linux-iscsi.org>
 <20110324102939R.fujita.tomonori@lab.ntt.co.jp> <1300949980.18039.222.camel@haakon2.linux-iscsi.org>
 <1301012333.4087.24.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54186 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099Ab1CYLcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2011 07:32:01 -0400
Received: by vws1 with SMTP id 1so698382vws.19
        for <linux-scsi@vger.kernel.org>; Fri, 25 Mar 2011 04:32:00 -0700 (PDT)
In-Reply-To: <1301012333.4087.24.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, bharrosh@panasas.com

On Fri, Mar 25, 2011 at 1:18 AM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Wed, 2011-03-23 at 23:59 -0700, Nicholas A. Bellinger wrote:
>> On Thu, 2011-03-24 at 10:29 +0900, FUJITA Tomonori wrote:
>> > On Wed, 23 Mar 2011 16:28:37 -0700
>> > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
>> >
>> > > > Hmm, you prefer 'zero C userspace code'? On the other hand, yo=
u insist
>> > > > that requiring user Python userspace code to set up ibmvscsis =
is a
>> > > > better approach even when the kernel space can set up everythi=
ng for
>> > > > ibmvscsis?
>> > > >
>> > >
>> > > Yes, because we expect userspace to drive creation of the curren=
t
>> > > configfs group layout.
>> > >
>> > > The configfs maintainer explictly requested to drop the ability =
to drive
>> > > the config_group creation from kernel-space that I had implement=
ed
>> > > originally, and which has not been included in the mainline targ=
et v4.0
>> > > control plane.
>> > >
>> > > It's folks like Joel and Greg-KH that need to be convinced in or=
der for
>> > > me to consider this type of logic for for mainline target code. =
=A0I do
>> >
>> > Can you stop insisting that configfs can't do that so the target c=
ore
>> > can't do that?
>> >
>>
>> That's certainly not what I am insisting upon. =A0I am trying to exp=
lain
>> that we currently have a configfs control plane that is native for
>> target mode.
>>
>> In the last three years to get to this point, I have developed proto=
type
>> code and asked upstream review for:
>>
>> *) Creating logic to drive configuration from kernel-space for confi=
gfs
>> *) Tried at creating sysfs -> configfs symlinks for referencing targ=
et
>> core backend devices
>>
>> So far both of these attempts at patches have been firmly rejected b=
y
>> the configfs and sysfs maintainers.
>>
>> I am not saying that configfs is the end-all for all generic target =
mode
>> control plane, but what I am saying is that I have yet to see the co=
de
>> for a different control plane that makes me want to move the away fr=
om a
>> 'native configfs' to 'a configfs/sysfs hyrbid', or something else al=
l
>> together for mainline target code.
>
> OK, so what about an upcall to userspace to create the necessary
> directories? =A0That could be driven by the kernel and still not requ=
ire
> any implementation in configfs.

Hi James,

I might have missed something, but which upcall mechanism are you
referring to ? Personally I'm not fond of the upcall concept because
as far as I can see any synchronous upcall mechanism can potentially
be used to trigger lock inversions not detectable by the PROVE_LOCKING
mechanism.

Regarding kernel-space driven directory creation in configfs: I have
been wondering whether it is possible to implement any configuration
filesystem such that directories can be created synchronously from
kernel space without triggering lock inversion. I don't see this as a
configfs limitation but as an inherent limitation of a configuration
filesystem. In a similar way a self-declarative kernel interface like
sysfs has the limitation that it is not possible to add configfs-style
configuration functionality without triggering lock inversion. Both
sysfs and configfs have important advantages over mechanisms like
ioctl() and netlink but there are some disadvantages too.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
