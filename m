From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [libsas PATCH v12 04/11] sysfs: handle 'parent deleted before
 child added'
Date: Thu, 22 Mar 2012 09:27:01 -0700
Message-ID: <CABE8wwtyxJaSfZREKRLDTZEef3nk=b+RFSe9i_UmV9knbQJ-tg@mail.gmail.com>
References: <20120322063127.22036.23206.stgit@dwillia2-linux.jf.intel.com>
	<20120322063214.22036.77957.stgit@dwillia2-linux.jf.intel.com>
	<20120322143959.GF19835@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120322143959.GF19835@kroah.com>
Sender: linux-ide-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 22, 2012 at 7:39 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Mar 21, 2012 at 11:32:14PM -0700, Dan Williams wrote:
[..]
>> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
>> index 7fdf6a7..86521ee 100644
>> --- a/fs/sysfs/dir.c
>> +++ b/fs/sysfs/dir.c
>> @@ -714,6 +714,9 @@ int sysfs_create_dir(struct kobject * kobj)
>> =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 parent_sd =3D &sysfs_root;
>>
>> + =A0 =A0 if (!parent_sd)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOENT;
>> +
>> =A0 =A0 =A0 if (sysfs_ns_type(parent_sd))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ns =3D kobj->ktype->namespace(kobj);
>> =A0 =A0 =A0 type =3D sysfs_read_ns_type(kobj);
>
> So what happens if this is true? =A0Does this patch fix the oops?

This patch downgrades the oops by turning it into a device_add()
failure, but the patches that *fix* this warning are here [1] and here
[2].

> What kernels should this be applied to where this problem has been se=
en?

I assume this has been a latent problem ever since scsi async scanning
was added (2.6.20-rc2), but it's a rare corner case to unplug devices
during the initial scan.

>> diff --git a/lib/kobject.c b/lib/kobject.c
>> index c33d7a1..e5f86c0 100644
>> --- a/lib/kobject.c
>> +++ b/lib/kobject.c
>> @@ -192,13 +192,14 @@ static int kobject_add_internal(struct kobject=
 *kobj)
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* be noisy on error issues */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (error =3D=3D -EEXIST)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR "%s failed=
 for %s with "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_err("%s failed for %s w=
ith "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"-EEXIST,=
 don't try to register things with "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"the same=
 name in the same directory.\n",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__,=
 kobject_name(kobj));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR "%s failed=
 for %s (%d)\n",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__, k=
object_name(kobj), error);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_err("%s failed for %s (=
error: %d parent: %s)\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__, k=
object_name(kobj), error,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0parent ? ko=
bject_name(parent) : "'none'");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 dump_stack();
>> =A0 =A0 =A0 } else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kobj->state_in_sysfs =3D 1;
>
> These changes have nothing to do with the above fix, so why include t=
hem
> here?

It wasn't until I realized which 'parent' and which 'child' were
interacting that I was able to identify the real fixes.  Since it was
helpful for the scsi/sas case, I decided to leave the more informative
warning for the next person that gets to debug a similar failure.

> And note, I hate pr_err(), what's wrong with printk() in this instanc=
e?

This is a bit circuitous, but extending the warning to include the
'parent' and 'child' pushed up against 80 columns and since this
routine has a pr_debug() a few lines up I thought a pr_ conversion was
acceptable.  The pr_err() conversion of the EEXIST case just came
along for the ride to keep the print style consistent (at least in
this routine).

--
Dan

[1]: http://marc.info/?l=3Dlinux-scsi&m=3D133239707903443&w=3D2
[2]: http://marc.info/?l=3Dlinux-scsi&m=3D133239709603452&w=3D2
