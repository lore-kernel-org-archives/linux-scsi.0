From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Fw: [Bugme-new] [Bug 6114] New: Initio sbp2 causes: "slab error
 in cache_free_debugcheck(): cache `size-512(DMA)': double free, or memory
 outside" object was overwritten
Date: Wed, 22 Feb 2006 01:34:42 +0100
Message-ID: <43FBB1A2.9030009@s5r6.in-berlin.de>
References: <20060221040511.35b69d26.akpm@osdl.org> <43FB6545.8080103@s5r6.in-berlin.de> <43FB67BD.7030101@s5r6.in-berlin.de> <20060221134543.5f844d7c.akpm@osdl.org> <43FB9FE5.8070309@s5r6.in-berlin.de> <Pine.LNX.4.64.0602220041070.21474@jbgna.fhfr.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.64.0602220041070.21474@jbgna.fhfr.qr>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: Bernhard Kaindl <bk@suse.de>
Cc: Al Viro <viro@ftp.linux.org.uk>, Andrew Morton <akpm@osdl.org>, bcollins@debian.org, scjody@modernduck.com, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>
List-Id: linux-scsi@vger.kernel.org

Bernhard Kaindl wrote:
> I tested the current ieee1394 cumulative patch in -mm1 from
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.16-rc4/2.6.16-rc4-mm1/broken-out/git-ieee1394.patch
> with my Initio and it still triggered the CONFIG_DEBUG_SLAB detector.

What I don't understand is why mode page 8 is still accessed in your 
log: http://bugzilla.kernel.org/attachment.cgi?id=7432&action=view
(Log lines "command: Mode Sense (10): 5a 00 08 00 00 00 00 00 d9 00", 
"SCSI transfer size = 17d9" --- yeah, into a 512 Bytes big buffer, "sda: 
got wrong page".) Could you please add a printk() or SBP2_INFO() within 
the if() clause of sbp2scsi_slave_alloc() to make sure it is entered? 
Could you also add the line
	SBP2_INFO("skip_ms_page_8 = %d", sdev->skip_ms_page_8);
before the return in sbp2scsi_slave_configure()? Not that your kernel 
looses the flag somewhere along the way...

> This patch from Al Viro fixed the slab message for me:
> 
> Re: TYPE_RBC cache fixes (sbp2.c affected)
> 2006-02-21 13:51
> http://sourceforge.net/mailarchive/message.php?msg_id=14879016
> 
> Bernhard
> --
> PS: My bug report for this was: http://bugzilla.kernel.org/show_bug.cgi?id=6114

Al's patch is certainly better since it adds checks to the actual 
affected code region, i.e. mode_sense handling in the SCSI layers. 
James, would you integrate this patch?

However sbp2 will keep some sort of skip_ms_page_8 blacklisting anyway 
because of different issues with other bridges.
-- 
Stefan Richter
-=====-=-==- --=- =-==-
http://arcgraph.de/sr/


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=103432&bid=230486&dat=121642
