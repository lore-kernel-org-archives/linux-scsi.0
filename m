From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: block: Handle cases where devices come online read-only
Date: Tue, 12 Feb 2019 11:26:46 -0500
Message-ID: <yq1h8d9ug55.fsf@oracle.com>
References: <20190208233831.31377-1-martin.petersen@oracle.com>
        <01000168dd40a901-e418f724-3fe3-47e3-bbea-05fea79f169e-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <01000168dd40a901-e418f724-3fe3-47e3-bbea-05fea79f169e-000000@email.amazonses.com>
        (Jeremy Cline's message of "Mon, 11 Feb 2019 15:50:28 +0000")
Sender: stable-owner@vger.kernel.org
To: Jeremy Cline <jeremy@jcline.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Oleksii Kurochko <olkuroch@cisco.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Jeremy,

> I noticed drivers/s390/block/dasd_ioctl.c calls set_disk_ro() to set the
> policy, where-as the policy is set with set_device_ro() in the generic
> ioctl.

There's a subtle distinction here:

 - set_disk_ro() sets the policy for a whole disk

 - set_device_ro() sets the policy for a block_device (typically
   partition)

> It's not setting the policy to DISK_POLICY_USER_WRITE_PROTECT so I
> think it would only be a problem if the user set it to 2 instead of 1
> assuming any truthy value is acceptable. Then the user wouldn't be
> able to mark the disk as writable again since this would be
> true. Perhaps it's a somewhat far-fetched scenario.

OK, I missed that particular entry point. Will fix.

-- 
Martin K. Petersen	Oracle Linux Engineering
