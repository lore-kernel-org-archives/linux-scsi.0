From: Andries.Brouwer@cwi.nl
Subject: Re: Isn't sd_major() broken ?
Date: Thu, 10 Apr 2003 22:46:23 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <UTC200304102046.h3AKkNl01295.aeb@smtp.cwi.nl>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, pbadari@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

    From: Badari Pulavarty <pbadari@us.ibm.com>

    I am little confused about the correctness of sd_major()
    in drivers/scsi/sd.c.

    Isn't sd_major() broken ? Here is the patch to fix it.

    --- drivers/scsi/sd.c.org    Wed Apr  9 13:12:38 2003
    +++ drivers/scsi/sd.c    Thu Apr 10 11:01:45 2003
    @@ -123,7 +123,7 @@ static int sd_major(int major_idx)
         case 1 ... 7:
             return SCSI_DISK1_MAJOR + major_idx - 1;
         case 8 ... 15:
    -        return SCSI_DISK8_MAJOR + major_idx;
    +        return SCSI_DISK8_MAJOR + major_idx - 8;
         default:
             BUG();
             return 0;    /* shut up gcc */

Yes.

The sd_major() patch was from hch in 2.5.51 - maybe you are
the first to use more than 8 majors.

Andries
