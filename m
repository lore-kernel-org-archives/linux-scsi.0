From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: ide-scsi cmd_per_lun
Date: Tue, 9 Jul 2002 17:18:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <000701c2278e$2dc723a0$e0019d89@cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have encountered another problem with ide-scsi.  My userspace program has
the sg device for an IDE tape drive open multiple times so that it can have
multiple outstanding commands.  The tape drive itself (like most tape
drives) does not support multiple outstanding commands.  The driver should
send the commands one at a time to the drive; having multiple outstanding
commands is merely a convenience for my program.

Let me use a concrete example to illustrate the problem.  I have /dev/sg0
open twice, yielding two file descriptors.  To the first file descriptor I
send a read(6) command, and then to the second file descriptor I send a test
unit ready command.  The ide-scsi driver sends the read command, which after
a several second medium access delay, returns CHECK CONDITION because of an
ILI (incorrect block size).  Next the ide-scsi driver sends the test unit
ready command.  Finally, the ide-scsi driver sends a request sense command
to recover the sense data from the read command's CHECK CONDITION.  This
obviously doesn't work as intended, since the test unit ready command has
reset the sense data.

The problem boils down to the fact that ide-scsi relies on the mid-level
(old eh) to do the auto-sense.  I was able to work around this problem by
setting cmd_per_lun: 1 in ide-scsi.h (vanilla 2.4.17).  Doing this caused
the request sense command to make it to the drive before any other command
could sneak in and reset the sense data.  Can anyone tell me if this is a
good solution?  Looking at the 2.4.19-rc1 source, I see an additional field
"can_queue: 10" in the template.  Should this be changed too?  I cannot use
2.4.19 for the moment, so I can't experiment with it.

Thanks,
Anthony J. Battersby
Cybernetics

