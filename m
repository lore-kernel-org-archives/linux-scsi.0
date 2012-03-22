From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [libsas PATCH v12 04/11] sysfs: handle 'parent deleted before
 child added'
Date: Thu, 22 Mar 2012 09:34:26 -0700
Message-ID: <CABE8wwsoPZuraV09OZzDF9bvLDjdZj95Wi6Q3d6S8RfAtfubQA@mail.gmail.com>
References: <20120322063127.22036.23206.stgit@dwillia2-linux.jf.intel.com>
	<20120322063214.22036.77957.stgit@dwillia2-linux.jf.intel.com>
	<1332427631.2946.19.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1332427631.2946.19.camel@dabdike.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 22, 2012 at 7:47 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2012-03-21 at 23:32 -0700, Dan Williams wrote:
>> In scsi at least two cases of the parent device being deleted before=
 the
>> child is added have been observed.
>>
>> 1/ scsi is performing async scans and the device is removed prior to=
 the
>> =A0 =A0async can thread running.
>
> This doesn't sound right. =A0We do an explicit get on the sdkp (and t=
he
> sdkp holds the sdp) before we schedule an async scan. =A0That's only
> removed after the async scan has completed, so it should be impossibl=
e
> for the parent to vanish.

Right, the parent does not get freed because we have a reference, but
it still gets device_del()'d which leads to:

  device_del()->kobject_del()->sysfs_remove_dir()

  kobj->sd =3D NULL;

=2E..and then sysfs_create_dir() (without this fix) goes ahead and
de-references parent_sd via sysfs_ns_type():

  return (sd->s_flags & SYSFS_NS_TYPE_MASK) >> SYSFS_NS_TYPE_SHIFT;

--
Dan
