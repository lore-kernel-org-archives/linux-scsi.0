From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: mvsas with 3.1 (mdraid+xfs locked up, single drive w/xfs not locked up)
Date: Mon, 16 Jan 2012 20:00:54 -0700
Message-ID: <201201162000.54940.thomas@fjellstrom.ca>
References: <201201131144.58044.thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201201131144.58044.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, ayan@marvell.com, andy yan <andyysj@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri Jan 13, 2012, Thomas Fjellstrom wrote:
> Is there chance this driver will ever be stable? After more than two years
> I'm starting to get extremely frustrated. I don't really have the option
> at the moment to get a new card, otherwise I would, likely a non marvell
> based device.
> 
> It actually managed to last 10 days this time though. Which is a record.
> The interesting thing is there are no warnings or errors in dmesg coming
> from the mvsas driver or scsi code. All that's happened is processes lock
> up when trying to write. Reading seems to be fine.
> 
> Just to refresh everyone's memory, it's a AOC-SASLP-MV8 card, has a
> MV64460/64461/64462 chipset. And I have 7 (seagate 7200.12 SATA drives
> hooked up).

I attached an 8th drive for kicks (for saving stuff temporarily that don't need 
to be on the big array), and if anything, the array locks up more than it did 
before. But there is one difference between the lockups that were happening and 
that are happening now. Now the entire array is still readable. It just locks 
up any process attempting to write to the array. Before both read and write 
would lock up, and a bunch of scary messages would hit dmesg. Now there are 
very few log messages about the array. In fact no messages show up from the 
scsi or other subsystems. The only evidence of "bad things" happening is the 
continual "process foo blocked for more than 120s" messages, and of course 
anything attempting to write to the array.

Here's something interesting though, I just tried writing to the one disk on 
the card that isn't part of the mdraid raid5 volume. It is fine. I can read 
from it and write to it. So something to do with mdraid, or the XFS filesystem 
(or both) is causing a bad interaction with the card itself.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
