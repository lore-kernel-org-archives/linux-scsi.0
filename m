From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: SCSI trees, merges and git status
Date: Mon, 18 Apr 2005 14:39:09 -0700 (PDT)
Message-ID: <Pine.LNX.4.58.0504181429570.15725@ppc970.osdl.org>
References: <1113856118.4998.70.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <git-owner@vger.kernel.org>
In-Reply-To: <1113856118.4998.70.camel@mulgrave>
Sender: git-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: git@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On Mon, 18 Apr 2005, James Bottomley wrote:
>
> As of today, I have two SCSI git trees operational:
> 
> rsync://www.parisc-linux.org/~jejb/scsi-rc-fixes-2.6.git

Merged. Here's the command line history:

	~/git/git-pull-script rsync://www.parisc-linux.org/~jejb/scsi-rc-fixes-2.6.git
	merge-cache ~/git/git-merge-one-file-script -a
	write-tree 
	commit-tree 2c8de70faf92af971667a26a6a397052fc572add -p $(cat .git/HEAD) -p $(cat .git/MERGE_HEAD)

ie the "git-pull-script" failed due to the content merge (I didn't trust 
the merge-cache stuff enough to put that into it), but then doing the 
automated merge was successful without any editing, so I just wrote the 
tree and committed it.

Again, if anybody wants to reproduce this, you'll need to then do the

	checkout-cache -f -a
	update-cace --refresh

afterwards to make your working area match the merged tree.

> Linus, the rc-fixes repo is ready for applying ... it's the same one I
> announced on linux-scsi and lkml a while ago just with the git date
> information updated to be correct (the misc one should wait until after
> 2.6.12 is final).

Ok. Can you verify? I did a "git diff" between your old head and my new
head, and it did not show any SCSI files (only the expected arm etc stuff
that you didn't have in your), so it all _looks_ good. But hey, just to
make sure that I didn't do anything stupid..

		Linus
