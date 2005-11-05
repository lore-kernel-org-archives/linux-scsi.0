From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: host lock in EH
Date: Fri, 04 Nov 2005 23:55:53 -0500
Message-ID: <436C3B59.7050202@pobox.com>
References: <436BFC3C.5030209@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <436BFC3C.5030209@s5r6.in-berlin.de>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Hi all,
> 
> some time ago eh_device_reset_handlers of most drivers were changed to 
> grab the host lock.
> http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=94d0e7b805961c44e4dc486ffc21075084bb7175 
> 
> 
> Are there general reasons to acquire the host lock in eh_s?

The patch you reference simply maintains existing locking rules, 
whatever they were at the time.

For drivers that unlocked the host lock and did their own thing, those 
lock manipulations simply went away.

For drivers that took no locks, they were updated to take the host lock 
since that is no longer done by the upper layers.

	Jeff





-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
