From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [patch] NCR5380.c fix
Date: Fri, 16 May 2003 09:16:25 +1000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3EC41FC9.4050504@torque.net>
References: <UTC200305152245.h4FMjAj26766.aeb@smtp.cwi.nl>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <UTC200305152245.h4FMjAj26766.aeb@smtp.cwi.nl>
To: Andries.Brouwer@cwi.nl
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Andries.Brouwer@cwi.nl wrote:
> Several SCSI drivers confuse CHECK_CONDITION and CHECK_CONDITION << 1.
<snip>

Linux has always had SCSI status values that are masked
(reasonable) and shifted one bit right (bizarre) from
the equivalent values in the SCSI standards. This
has tricked lots of people.

So in lk 2.5 saner defines (with long-winded names)
have been introduced:
....
#define SAM_STAT_CHECK_CONDITION 0x02
....

The appropriate mask is now 0x7e since Linux uses
the upper bytes and the vendor could (but seldom)
use bits 0 and 7. We should have a constant or macro
for this mask.

So in lk 2.5 your check could read:

    if ((cmd->SCp.Status & 0x7e) == SAM_STAT_CHECK_CONDITION)


Aside: "SAM" stands for SCSI Architecture Model which is the
modern standard that defines SCSI status values.

Doug Gilbert
