From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] scsi: fix scsi_error_handler vs. scsi_host_dev_release race
Date: Thu, 27 Aug 2015 11:28:05 -0700
Message-ID: <CAPcyv4hYtKNgLoOBKfvUx==LnK34Ve7K+oYq7j1g6r0pAY8Cqg@mail.gmail.com>
References: <1440699420-30499-1-git-send-email-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440699420-30499-1-git-send-email-mhocko@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mhocko@kernel.org
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 27, 2015 at 11:16 AM,  <mhocko@kernel.org> wrote:
> From: Michal Hocko <mhocko@suse.com>
>
> b9d5c6b7ef57 ("[SCSI] cleanup setting task state in
> scsi_error_handler()") has introduced a race between scsi_error_handler
> and scsi_host_dev_release resulting in the hang when the device goes
> away because scsi_error_handler might miss a wake up:
>
> CPU0                                    CPU1
> scsi_error_handler                      scsi_host_dev_release
>                                           kthread_stop()
>   kthread_should_stop()
>     test_bit(KTHREAD_SHOULD_STOP)
>                                             set_bit(KTHREAD_SHOULD_STOP)
>                                             wake_up_process()
>                                             wait_for_completion()
>
>   set_current_state(TASK_INTERRUPTIBLE)
>   schedule()
>
> The most straightforward solution seems to be to invert the ordering of
> the set_current_state and kthread_should_stop.
>
> The issue has been noticed during reboot test on a 3.0 based kernel but
> the current code seems to be affected in the same way.
>
> Cc: stable # 3.6+
> Reported-and-Debugged-by: Mike Mayer <Mike.Meyer@teradata.com>
> Signed-off-by: Michal Hocko <mhocko@suse.com>

Acked-by: Dan Williams <dan.j.williams@intel.com>
