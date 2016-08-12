From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 2/2] libata-core: do not set dev->max_sectors for LBA48 devices
Date: Thu, 11 Aug 2016 22:01:58 -0400
Message-ID: <yq1mvkipwx5.fsf@sermon.lab.mkp.net>
References: <5eceeb9ad825beb87db03b0989f746dfbe0cf3fe.1470753817.git.tom.ty89@gmail.com>
	<10c4d38005e24bb477b5182d4fc17879139f14d9.1470753817.git.tom.ty89@gmail.com>
	<20160810041042.GH25053@mtj.duckdns.org>
	<CAGnHSE=z78AjDC13XKk_WnkQcjFHWGcatciwoJJYW-97a0qWjQ@mail.gmail.com>
	<yq1twesq8lm.fsf@sermon.lab.mkp.net>
	<CAGnHSEn3pXR33Ju+mr0DYdE0G7kNhxNCbvocX1pZXvYfxx5+3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAGnHSEn3pXR33Ju+mr0DYdE0G7kNhxNCbvocX1pZXvYfxx5+3A@mail.gmail.com>
	(Tom Yan's message of "Thu, 11 Aug 2016 17:30:59 +0800")
Sender: linux-ide-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, jmoyer@redhat.com, axboe@fb.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Hey Tom,

Tom> Shouldn't we use Maximum Transfer Length to derive max_sectors (and
Tom> get rid of the almost useless max_dev_sectors)?

MAXIMUM TRANSFER LENGTH could be gigabytes. Some disks report it as the
full capacity of the device.

Again, the point of max_hw_sectors and max_dev_sectors is to enforce the
hard limits of controller and device respectively. Nothing else.

max_sectors is a soft limit for filesystem read/write requests and is
chosen to be a sane default for common workloads. It can be bumped (up
to the smaller of the hard limits) if the user so desires.

Tom> Honestly it looks pretty non-sensical to me that the SCSI disk
Tom> driver uses Optimal Transfer Length for max_sectors.

OPTIMAL TRANSFER LENGTH is there to address a very specific problem,
namely avoiding partial stripe writes on RAID arrays.

For almost all other device classes it is not reported and it makes no
sense to do so. For those remaining devices BLK_DEF_MAX_SECTORS comes
into play.

Tom> But the biggest problem isn't on bumping it, but the value picked
Tom> is totally irrational for a general default. I mean, given that it
Tom> was 1024 (512k), try to double it? Fine. Try to quadruple it?
Tom> Alright.  We'll need to deal with some alignment / boundary issue
Tom> (like the typical 65535 vs 65536 case)? Okay let's do it. But
Tom> what's the sense in picking a random RAID configuartion as the base
Tom> to decide the default?

I agree that the new default is completely arbitrary. And I think there
was a bit of controversy at the time. However, the numbers were
compelling so the change went in.

We are open to a discussion about what the default should be. But it
involves backing the discussion up with solid data.

Tom> So we should use also SCSI_DEFAULT_MAX_SECTORS in the SCSI disk
Tom> driver as fallback for max_sectors. If the value is considered to
Tom> low even as a safe fallback, then it should be bumped
Tom> appropriately. (Or we might want to replace it with
Tom> BLK_DEF_MAX_SECTORS everywhere in the SCSI layer, that said, after
Tom> the value is fixed.)

SCSI_DEFAULT_MAX_SECTORS is there to provide a safe max for legacy SCSI
controller drivers that haven't been updated or tested with larger
transfers. It has nothing to do with sd drive limits or block layer
defaults.

-- 
Martin K. Petersen	Oracle Linux Engineering
