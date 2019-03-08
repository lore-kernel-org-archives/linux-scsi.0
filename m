From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi:libiscsi: Hold back_lock when calling iscsi_complete_task
Date: Thu, 07 Mar 2019 21:38:04 -0500
Message-ID: <yq14l8et7jn.fsf@oracle.com>
References: <20190225174130.29496-1-leeman.duncan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190225174130.29496-1-leeman.duncan@gmail.com> (Lee Duncan's
        message of "Mon, 25 Feb 2019 09:41:30 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <leeman.duncan@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, cleech@redhat.com, hare@suse.de, Lee Duncan <lduncan@suse.com>
List-Id: linux-scsi@vger.kernel.org


Lee,

> If there is an error queueing an iscsi command in
> iscsi_queuecommand(), for example if the transport fails to take the
> command in sessuin->tt->xmit_task(), then the error path can call
> iscsi_complete_task() without first aquiring the back_lock as
> required. This can lead to things like ITT pool can get corrupt,
> resulting in duplicate ITTs being sent out.
>
> The solution is to hold the back_lock around iscsi_complete_task()
> calls, and to add a little commenting to help others understand when
> back_lock must be held.

Applied to 5.1/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
