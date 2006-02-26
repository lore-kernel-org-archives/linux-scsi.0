From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [stable] [PATCH 1/2] sd: fix memory corruption by sd_read_cache_type
Date: Sun, 26 Feb 2006 05:45:02 -0500
Message-ID: <440186AE.2@pobox.com>
References: <tkrat.014f03dc41356221@s5r6.in-berlin.de> <20060225021009.GV3883@sorel.sous-sol.org> <4400E34B.1000400@s5r6.in-berlin.de> <Pine.LNX.4.64.0602251600480.22647@g5.osdl.org> <20060226001716.GL27946@ftp.linux.org.uk> <Pine.LNX.4.64.0602251626280.22647@g5.osdl.org> <44016956.2030609@pobox.com> <20060226090024.GO27946@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:26270 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751072AbWBZKp3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Feb 2006 05:45:29 -0500
In-Reply-To: <20060226090024.GO27946@ftp.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@osdl.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Chris Wright <chrisw@sous-sol.org>, stable@kernel.org, Jody McIntyre <scjody@modernduck.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Junio C Hamano <junkio@cox.net>

Al Viro wrote:
> On Sun, Feb 26, 2006 at 03:39:50AM -0500, Jeff Garzik wrote:
> 
>>Any chance we could get 'git fetch --heads' ?
>>
>>FWIW, I regularly blow away and create new heads, so the above is rather 
>>long for people who use my repos.  A lot of them use rsync because when 
>>you're tracking a repo with ever-changing branches, 'git pull' doesn't 
>>really approximate "make local X look like remote X".
> 
> 
> Speaking of which...  Shouldn't git clone bring in .git/HEAD for rsync:// URLs?
> As it is, we end up with HEAD pointing to refs/master, which might simply
> not be there.  For git:// we get .git/HEAD same as in remote repository,
> so behaviour for rsync:// probably should be the same...
> 
> Looks like a missing rsync in git-clone, around
>         rsync://*)
>                 rsync $quiet -av --ignore-existing  \
>                         --exclude info "$repo/objects/" "$GIT_DIR/objects/" &&
>                 rsync $quiet -av --ignore-existing  \
>                         --exclude info "$repo/refs/" "$GIT_DIR/refs/" || exit
> 
> Comments?

AFAICS 'git clone $rsync_url' pulls down the heads and tags just fine... 
  I just tried it again to be certain.  refs/heads and refs/tags is 
fully populated, and HEAD links to refs/master as it should.

	Jeff



