From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over 10GbE?
Date: Sun, 06 Feb 2011 16:01:33 -0600
Message-ID: <4D4F1A3D.2090107@hardwarefreak.com>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan> <20110205214550.3cb0f0d1@galadriel2.home> <alpine.DEB.2.00.1102051553591.8518@p34.internal.lan> <20110205220621.GB17347@gallifrey> <alpine.DEB.2.00.1102051729010.8518@p34.internal.lan> <alpine.DEB.2.00.1102051753100.8518@p34.internal.lan> <4D4DE34E.7010308@hardwarefreak.com> <alpine.DEB.2.00.1102051958370.28109@p34.internal.lan> <4D4E127D.3060105@hardwarefreak.com> <alpine.DEB.2.00.1102060515230.28109@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1102060515230.28109@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>, Emmanuel Florac <eflorac@intellique.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org

Justin Piszcz put forth on 2/6/2011 4:16 AM:

> Workflow process-
> 
> Migrate data from old/legacy RAID sets to new ones, possibly also 2TB->3TB, so
> the faster the transfer speed, the better.

This type of data migration is probably going to include many many files of
various sizes from small to large.  You have optimized your system performance
only for individual large file xfers.  Thus, when you go to copy directories
containing hundreds or thousands of files of various sizes, you will likely see
much lower throughput using a single copy stream.  Thus if you want to keep that
10 GbE pipe full, you'll likely need to run multiple copies in parallel, one per
large parent directory.  Or, run a single copy from say, 10 legacy systems to
one new system simultaneously, etc.

Given this situation, you may want to consider tar'ing up entire directories
with gz or bz compression, if you have enough free space on the legacy machines,
and copying the tarballs to the new system.  This will maximize your throughput,
although I don't know if it will decrease your total work flow completion time,
which should really be your overall goal.

-- 
Stan
