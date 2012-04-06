From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 1/2] sysfs: handle 'parent deleted before child added'
Date: Fri, 6 Apr 2012 14:44:37 -0700
Message-ID: <CABE8wwv9NUGz56M+GANzG2zDkANm4vAMT_vde0FpamhvC7B8pg@mail.gmail.com>
References: <20120406203619.22624.69445.stgit@dwillia2-linux.jf.intel.com>
	<20120406204514.GA20237@kroah.com>
	<CABE8wwuMyH7nrPZWarWw1Z8=oM_Z4eUcupnsyxA9NF=Y1R_Apw@mail.gmail.com>
	<20120406211711.GA12075@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120406211711.GA12075@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: James Bottomley <JBottomley@parallels.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 6, 2012 at 2:17 PM, Greg KH <gregkh@linuxfoundation.org> wr=
ote:
> On Fri, Apr 06, 2012 at 02:06:50PM -0700, Williams, Dan J wrote:
>> On Fri, Apr 6, 2012 at 1:45 PM, Greg KH <gregkh@linuxfoundation.org>=
 wrote:
>> > On Fri, Apr 06, 2012 at 01:41:06PM -0700, Dan Williams wrote:
>> >> In scsi at least two cases of the parent device being deleted bef=
ore the
>> >> child is added have been observed.
>> >>
>> >> 1/ scsi is performing async scans and the device is removed prior=
 to the
>> >> =A0 =A0async can thread running (can happen with an in-opportune =
/ unlikely
>> >> =A0 =A0unplug during initial scan).
>> >
>> > That sounds like a bug in the scsi code, doesn't it?
>> >
>> >> 2/ libsas discovery event running after the parent port has been =
torn
>> >> =A0 =A0down (this is a bug in libsas).
>> >
>> > Is this fixed somewhere?
>>
>> Yes, these two issues have pending fixes that are posted to linux-sc=
si:
>>
>> http://marc.info/?l=3Dlinux-scsi&m=3D133239707903443&w=3D2
>> http://marc.info/?l=3Dlinux-scsi&m=3D133239709603452&w=3D2
>>
>> > I don't want to paper over bugs like this by changing the sysfs co=
re.
>> > We went through this a lot years ago when scsi changed to use the =
driver
>> > core, and I thought we had fixed all of these types of errors prop=
erly.
>>
>> Hotplug lifetime rules are still transport specific. =A0So in this c=
ase
>> scsi-core is innocent these are bugs from libsas and
>> scsi_transport_sas.
>
> Ok, thanks for the explaination.
>
>> > So, any chance to fix these properly as well?
>>
>> This patch doesn't really paper over anything. =A0It turns a NULL
>> pointer crash into an explicit warning from kobject_add_internal. =A0=
=46or
>> the libsas/scsi case this device_add() failure is still fatal.
>> Regardless of whether sysfs changes the above two fixes are still
>> required.
>>
>> Since the -EEXIST case is just a KERN_ERR and not a BUG_ON I figured
>> it was worthwhile to post a patch to do the same for this 'parent
>> deleted' case. =A0But if crashing is the expectation then this patch=
 can
>> be dropped.
>
> No, crashing is not the expectation :)

I thought not, but sometimes the kernel likes to teach people that
bollix an api a hard lesson :).

>
> But, without that crash, would the above fixes ever have been noticed
> and fixed? =A0The device_add() most likely would have quietly failed =
and
> no one would have been the wiser.
>
> Or would something else have caused this to be an obvious problem?
>

We still have the big red flag dump_stack() in kobject_add_internal()
(which patch 2 turns into a real WARN()), and for scsi our hotplug
tests still crash later on because libsas makes assumptions about the
device path.  I understand the paranoia here,  "check for NULL" is
usually a band-aid, but in this case this is just a softer
introduction to a debug session.  No less vocal than before as far as
I can see.

--
Dan
