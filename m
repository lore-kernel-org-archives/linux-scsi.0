From: Willem Riede <wrlk@riede.org>
Subject: Re: [PATCH] Eliminate signals entirely from the mid-layer
Date: Sat, 11 Jan 2003 09:23:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030111142311.GQ1378@linnie.riede.org>
References: <200301102119.h0ALJUf05888@localhost.localdomain>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200301102119.h0ALJUf05888@localhost.localdomain>; from James.Bottomley@steeleye.com on Fri, Jan 10, 2003 at 16:19:30 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On 2003.01.10 16:19 James Bottomley wrote:
> the attached patch removes SCSI's use of signals for killing the error handler 
> thread.  It also:
> 
> - changes the eh_notify semaphore to a completion
> - adds complete_and_exit() to the thread
> - uses a host structure flag to signal thread death instead of the signal
> 
> I'm currently travelling, so could someone test it out for me?  Thanks,
> 
Sorry, James,

When I apply your patch, rmmod ide-scsi hangs. This is my log:

Jan 11 09:08:06 fallguy kernel: Error handler scsi_eh_2 waking up
Jan 11 09:08:06 fallguy kernel: Total of 0 commands on 0 devices require eh work
Jan 11 09:08:06 fallguy kernel: scsi_eh_get_sense: checking to see if we need to request sense
Jan 11 09:08:06 fallguy kernel: scsi_restart_operations: waking up host to restart
Jan 11 09:08:06 fallguy kernel: Error handler scsi_eh_2 sleeping

and ps shows:

...
040     0   236     1  15   0     0    0 down_i SW   ?          0:00 [scsi_eh_2]
...
100     0   946   887  16   0  1324  380 scsi_u D    pts/0      0:00 rmmod ide-scsi
044     0   947   946  16   0     0    0 do_exi Z    pts/0      0:00 [kmodule0? <defunct>]
...

Regards, Willem Riede.
