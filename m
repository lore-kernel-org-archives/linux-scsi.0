From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Warning - running *really* short on DMA buffers while doing
 file  transfers
Date: Fri, 27 Sep 2002 16:48:54 -0600
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <2698376224.1033166934@aslan.btc.adaptec.com>
References: <200209271721.g8RHLTn05231@localhost.localdomain>
 <2628736224.1033160295@aslan.btc.adaptec.com>
 <20020927143841.A17108@eng2.beaverton.ibm.com>
 <2668366224.1033164502@aslan.btc.adaptec.com>
 <20020927152842.A18038@eng2.beaverton.ibm.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="==========3294902874=========="
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20020927152842.A18038@eng2.beaverton.ibm.com>
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@suse.de>, Matthew Jacob <mjacob@feral.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--==========3294902874==========
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> I turned on the debug flags, there were a bunch of odd messages
> in there, but otherwise it seems to be working fine. My .config
> has the following AIC config options:

<sigh>
I always run with debugging turned on with the message flags enabled,
so I missed this in my testing.  I just updated the tarfile.  The
following patch is all you need to shut the driver up.

--
Justin

--==========3294902874==========
Content-Type: text/plain; charset=us-ascii; name=diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=diff; size=1375

Change 1419 by gibbs@bitkeeper-linux-2.5 on 2002/09/27 16:44:04

	Add a missing pair of curly braces to a conditional debug
	statement.  This ensures that debug code doesn't trigger if
	it isn't enabled. <blush>

Affected files ...

... //depot/aic7xxx/aic7xxx/aic7xxx.c#80 edit

Differences ...

==== //depot/aic7xxx/aic7xxx/aic7xxx.c#80 (ktext) ====

***************
*** 37,43 ****
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
!  * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.c#79 $
   *
   * $FreeBSD$
   */
--- 37,43 ----
   * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   * POSSIBILITY OF SUCH DAMAGES.
   *
!  * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.c#80 $
   *
   * $FreeBSD$
   */
***************
*** 2475,2483 ****
  			panic("HOST_MSG_LOOP interrupt with no active message");
  
  #ifdef AHC_DEBUG
! 		if ((ahc_debug & AHC_SHOW_MESSAGES) != 0)
  			ahc_print_devinfo(ahc, &devinfo);
  			printf("INITIATOR_MSG_OUT");
  #endif
  		phasemis = bus_phase != P_MESGOUT;
  		if (phasemis) {
--- 2475,2484 ----
  			panic("HOST_MSG_LOOP interrupt with no active message");
  
  #ifdef AHC_DEBUG
! 		if ((ahc_debug & AHC_SHOW_MESSAGES) != 0) {
  			ahc_print_devinfo(ahc, &devinfo);
  			printf("INITIATOR_MSG_OUT");
+ 		}
  #endif
  		phasemis = bus_phase != P_MESGOUT;
  		if (phasemis) {

--==========3294902874==========--
