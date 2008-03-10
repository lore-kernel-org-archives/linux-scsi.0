From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: data corruption: ext3/lvm2/md/mptsas/vitesse/seagate
Date: Mon, 10 Mar 2008 14:55:42 -0500
Message-ID: <1205178942.2941.20.camel@localhost.localdomain>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
	 <1204848652.3062.100.camel@localhost.localdomain>
	 <200803101519.m2AFJCJS032509@colby.verdasys.com>
	 <1205163386.2941.14.camel@localhost.localdomain>
	 <20080310200225.1b9914e3@szpak>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080310200225.1b9914e3@szpak>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-03-10 at 20:02 +0100, Janek Kozicki wrote:
> James Bottomley said:     (by the date of Mon, 10 Mar 2008 10:36:26 -0500)
> 
> 
> > I'm afraid the only way to confirm this theory definitively will be with
> > the destructive disktest
> 
> you can try this destructive test:
> 
>   badblocks -c 10240 -s -w -t random -v /dev/sdc
> 
> or use smaller value for -c if you wish.

No, you can't (at least not to prove what I think the problem is).

That test is looking for media failure and uses special write patterns
to try to find it.  We're looking for head misplacement.

The reason for using the disktest test is that it specifically writes
the block number into the block ... and it compares it back on read.
The test will definitively pick up any misplaced sector write errors
done by the disk.

James


