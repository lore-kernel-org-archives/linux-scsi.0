From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
Date: Sun, 01 Feb 2009 13:14:48 +0900
Message-ID: <498521B8.1020703@kernel.org>
References: <1233456951-992-1-git-send-email-tj@kernel.org>
	<49851507.5040905@garzik.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49851507.5040905@garzik.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-ide@vger.kernel.org, dm-devel@redhat.com, Mauelshagen@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hello, Jeff.

Jeff Garzik wrote:
> But the net result is that you are telling dmraid that it is OK to
> proceed, even though part of the disk it wants is really missing.  That
> seems unwise, because are you not basically proceeding with a known
> corrupt dataset at that point?

Can you elaborate a bit?  I don't really understand what you mean.  To
clarify...

* What happens now.

BIOS sets up HPA expecting the raid driver to look at the metadata
which is at fixed offset from the end of the HPA locked size.  dmraid
doesn't know about it so looks at the wrong place.  Results can be
failed assembly or corrupt assembly depending on what's actually on
the disk.

* With the patches applied.

BIOS does the same but libata tells dmraid the BIOS size.  dmraid
looks at the same offset as the BIOS and everything is well.

Thanks.

-- 
tejun
