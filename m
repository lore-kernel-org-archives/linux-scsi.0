From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] ieee1394: sbp2: pass REQUEST_SENSE through to the target
Date: Thu, 28 Dec 2006 13:54:06 -0700
Message-ID: <20061228205406.GC20153@parisc-linux.org>
References: <tkrat.9e24970727f8c664@s5r6.in-berlin.de>
	<45942759.8080804@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <45942759.8080804@torque.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Douglas Gilbert <dougg@torque.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 28, 2006 at 03:21:45PM -0500, Douglas Gilbert wrote:
> So, this patch is a step in the right direction.
> Hopefully not too many other LLDs are playing
> games with REQUEST SENSE.

A lot of drivers play games with REQUEST_SENSE, but they mostly seem to
be doing things with their own internal state.  One suspicious one is
BusLogic.c :

        /*
           SCSI REQUEST_SENSE commands will be executed automatically by the Host
           Adapter for any errors, so they should not be executed explicitly unless
           the Sense Data is zero indicating that no error occurred.
         */
        if (CDB[0] == REQUEST_SENSE && Command->sense_buffer[0] != 0) {
                Command->result = DID_OK << 16;
                CompletionRoutine(Command);
                return 0;
        }

I don't know if this is OK for your scenario or not.

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
