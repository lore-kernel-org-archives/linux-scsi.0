From: Andries.Brouwer@cwi.nl
Subject: 2.5.63/64 do not boot: loop in scsi_error
Date: Thu, 6 Mar 2003 02:01:38 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <UTC200303060101.h2611cg08660.aeb@smtp.cwi.nl>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, torvalds@transmeta.com
List-Id: linux-scsi@vger.kernel.org

See that 2.5.64 came out - good. Time to send the next dev_t patch.
Unfortunately 2.5.63 and 2.5.64 do not boot.

A moment ago I looked at what goes wrong, and it turns out that
scsi_error is activated
  [always a bad sign - I have never see it do any good, and
   often see it crash the machine]
and an infinite loop occurs, leaving the machine rather dead.

(Total of 1 commands require eh work; scsi_unjam_host; requesting sense;
 scsi_eh_done: result 0) - infinite repeat.

Have no time tonight to make a patch, but I suppose the author of
the 2.5.63 scsi_error.c changes knows what she did wrong.

Andries


[I can make 2.5.64 boot if I make sure no errors ever occur.
That means that I must disable get_evpd_page, get_serialnumber,
get_cachetype that my old stuff doesnt know about.
If I do that all is well.]
