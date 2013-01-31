From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] don't wait on disk to start on resume
Date: Fri, 01 Feb 2013 09:27:37 +1100
Message-ID: <1359671257.7527.4.camel@dabdike>
References: <1356064540-17414-1-git-send-email-dbasehore@chromium.org>
	 <50D5C473.2030902@mvista.com>
	 <CAGAzgso4cJHM+CNV0nCu6zUmq=xUstbsguynUp+hyx581LcHJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGAzgso4cJHM+CNV0nCu6zUmq=xUstbsguynUp+hyx581LcHJg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "dbasehore ." <dbasehore@chromium.org>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-01-31 at 14:00 -0800, dbasehore . wrote:
> (Resending as plain text so the message is tracked on vger)
> 
> Hi, thanks for reading through my patch.
> 
> With regards to SCSI_SENSE_BUFFERSIZE, I'm following the precedent of
> scsi_execute_req found in drivers/scsi/scsi_lib.c

I have no context for this: I don't recall making any comment on sense
buffers; what are you replying to?

James

> It seems that it is used by the scsi_normalize_sense function which I
> call in sd_resume_async. I just input SCSI_SENSE_BUFFERSIZE directly
> there though. I didn't know if anything would change its behavior on a
> lower level if I made sense_len = SCSI_SENSE_BUFFERSIZE, so I just
> went with what was already done.
> 
> I'll make sure the semantic fixes go into the final patch.
> 
> Also, I forgot to mention one possible problem earlier. I understand
> that some hard drives have a command buffer that can be executed by
> the hard drive in an order it determines. Does anyone know of a
> potential problem if the following happens?
> 
> -resume finishes (hard drive not started yet)
> -read/write sent to disk, inserted before start command
> 
> Could this happen? If so, could it cause any problems?
> 
> I've tested the possibility of a program trying to read/write from the
> disk before it has started, and the read/write blocks until the disk
> has actually been spun up. I don't know if there are specific hard
> drives where this could be a problem though.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
