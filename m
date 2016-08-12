From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 2/2] libata-core: do not set dev->max_sectors for LBA48 devices
Date: Fri, 12 Aug 2016 17:06:34 -0400
Message-ID: <yq1h9apn1d1.fsf@sermon.lab.mkp.net>
References: <5eceeb9ad825beb87db03b0989f746dfbe0cf3fe.1470753817.git.tom.ty89@gmail.com>
	<10c4d38005e24bb477b5182d4fc17879139f14d9.1470753817.git.tom.ty89@gmail.com>
	<20160810041042.GH25053@mtj.duckdns.org>
	<CAGnHSE=z78AjDC13XKk_WnkQcjFHWGcatciwoJJYW-97a0qWjQ@mail.gmail.com>
	<yq1twesq8lm.fsf@sermon.lab.mkp.net>
	<CAGnHSEn3pXR33Ju+mr0DYdE0G7kNhxNCbvocX1pZXvYfxx5+3A@mail.gmail.com>
	<yq1mvkipwx5.fsf@sermon.lab.mkp.net>
	<CAGnHSEm0mGPG_y2a7hmCzQkwYE23Srozrm6eSPX8a3Q9a0y+7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAGnHSEm0mGPG_y2a7hmCzQkwYE23Srozrm6eSPX8a3Q9a0y+7A@mail.gmail.com>
	(Tom Yan's message of "Fri, 12 Aug 2016 13:18:28 +0800")
Sender: linux-block-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, jmoyer@redhat.com, axboe@fb.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom,

Tom> Sounds like libata-scsi is doing something wrong then. It should
Tom> not set max_hw_sectors to dev->max_sectors that is set by
Tom> libata-core:

Tom> but instead it should report it as Maximum Transfer Length and let
Tom> sd set it as max_dev_sectors:

Well, it's mostly academic since there is a 1:1 mapping. It is important
in SCSI where you have many devices with different properties hooked up
to the same controller.

SCSI MTL is a recent addition. There wasn't much point in making a
distinction between hw and dev outside of sd.c since it is the only
device type that has a way to communicate a transfer limit.

Tom> Although that means setting dev->max_sectors to a value larger than
Tom> 1024 will probably be a no-op, if that's really an issue, we should
Tom> have the host templates in libata updated.

I am still not sure exactly which problem it is you are trying to fix?

-- 
Martin K. Petersen	Oracle Linux Engineering
