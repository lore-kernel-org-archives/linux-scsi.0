From: Steven Haber <steven@qumulo.com>
Subject: Re: [v3.16][v3.17][v3.18][ Regression] scsi: handle flush errors properly
Date: Wed, 10 Dec 2014 15:06:50 -0800
Message-ID: <CAPK7rjejMdQ45sVS-ebnqmeYWz3vqaYVXxTdVwUzhByB+nbsLA@mail.gmail.com>
References: <5488C478.9000209@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <5488C478.9000209@canonical.com>
Sender: stable-owner@vger.kernel.org
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: JBottomley@parallels.com, "Martin K. Petersen" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hey Joe,

Here's some context:

The SCSI flush command was being treated by a zero-byte write, which
means that if an error was returned, you wouldn't catch it until a
subsequent write (or flush). The way writes work is that all possible
bytes are written, and if something bad happens, an error bubbles out
on the next write attempt. This holds true even for a zero-byte write.
This means that before this bug, to guarantee durability you had to
flush twice (and verify both were error-free). I'm working on a
storage appliance that relies on the fact that a single flush command
guarantees a write made durably to a SCSI device. I'm sure many other
storage products rely on this behavior, too. The patch James shipped
fixes this bug by special-casing the flush error path. Before flush
wouldn't return errors; now it does.

I'm not sure why certain USB drives are failing in the flush path on
unmount. Since the flush bug existed for such a long time, I suspect
certain drivers coded around this behavior, and now that it is correct
we are seeing new bugs exposed.

Based on the simplicity and obviousness of our patch for the flush
bug, it would really be ideal to diagnose this further rather than
reverting.

Steven Haber
Qumulo, Inc.

On Wed, Dec 10, 2014 at 2:08 PM, Joseph Salisbury
<joseph.salisbury@canonical.com> wrote:
> Hello James,
>
> A kernel bug report was opened against Ubuntu [0].  After a kernel
> bisect, it was found that reverting the following commit resolved this bug:
>
> commit 89fb4cd1f717a871ef79fa7debbe840e3225cd54
> Author: James Bottomley <JBottomley@Parallels.com>
> Date:   Thu Jul 3 19:17:34 2014 +0200
>
>     scsi: handle flush errors properly
>
> The regression was introduced as of v3.16 and still exits in the 3.18
> kernel.  It has also made it's way into the stable kernels.
>
> I was hoping to get your feedback, since you are the patch author.  Do
> you think gathering any additional data will help diagnose this issue,
> or would it be best to submit a revert request?
>
>
> Thanks,
>
> Joe
>
> [0] http://pad.lv/1366538
>
