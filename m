From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [libsas PATCH v12 04/11] sysfs: handle 'parent deleted before
 child added'
Date: Fri, 23 Mar 2012 14:15:24 -0700
Message-ID: <CABE8wwsjmtOhb8QTQwE4TkiVr9RduWON81qQsX=qKh8UhSU4gQ@mail.gmail.com>
References: <20120322063127.22036.23206.stgit@dwillia2-linux.jf.intel.com>
	<20120322063214.22036.77957.stgit@dwillia2-linux.jf.intel.com>
	<20120322143959.GF19835@kroah.com>
	<1332528209.23830.4.camel@ultramagnus.opencreations.com>
	<20120323205424.GA31689@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120323205424.GA31689@kroah.com>
Sender: linux-ide-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 23, 2012 at 1:54 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Mar 23, 2012 at 11:43:28AM -0700, Dan Williams wrote:
>> On Thu, 2012-03-22 at 07:39 -0700, Greg Kroah-Hartman wrote:
>> > And note, I hate pr_err(), what's wrong with printk() in this inst=
ance?
>>
>> So how about an end run around the conversion to pr_err() and just m=
ake
>> these proper WARN()s since we end up calling dump_stack in both case=
s?
>>
>> Something like:
>>
>> diff --git a/lib/kobject.c b/lib/kobject.c
>> index e5f86c0..1bd0893 100644
>> --- a/lib/kobject.c
>> +++ b/lib/kobject.c
>> @@ -192,15 +192,14 @@ static int kobject_add_internal(struct kobject=
 *kobj)
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* be noisy on error issues */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (error =3D=3D -EEXIST)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_err("%s failed for %s w=
ith "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"-EEXIST, d=
on't try to register things with "
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"the same n=
ame in the same directory.\n",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__, k=
object_name(kobj));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN(1, "%s failed for %s =
with "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"-EEXIST, don't=
 try to register things with "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"the same name =
in the same directory.\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__, kobje=
ct_name(kobj));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_err("%s failed for %s (=
error: %d parent: %s)\n",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__, k=
object_name(kobj), error,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0parent ? ko=
bject_name(parent) : "'none'");
>> - =A0 =A0 =A0 =A0 =A0 =A0 dump_stack();
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN(1, "%s failed for %s =
(error: %d parent: %s)\n",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__, kobje=
ct_name(kobj), error,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0parent ? kobjec=
t_name(parent) : "'none'");
>
> I'm missing why this isn't the exact same thing that is currently
> happening...
>
> confused,

WARN does wrap the printk and backtrace in "------------[ cut here
]------------\n" and "---[ end trace %016llx ]---\n" so automated
tools can pick it up, maybe that's useful in a core routine like this?

It's still modifying the else case to add the faulting child and
parent kobject names, and does so without setting a pr_ conversion
precedent in sysfs.

--
Dan
