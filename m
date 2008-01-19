From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Bug 9734] New: I/O error when inserting a second firewire sata
	disk
Date: Sat, 19 Jan 2008 14:20:19 +0100 (CET)
Message-ID: <tkrat.da7b74482b7735a6@s5r6.in-berlin.de>
References: <bug-9734-11613@http.bugzilla.kernel.org/>
	<1200186705.3656.83.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1200186705.3656.83.camel@localhost.localdomain>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kristian Hoegsberg <krh@bitplanet.net>, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
List-Id: linux-scsi@vger.kernel.org

I did a quick and simple test now:

  1.) switch on 1st disk (sdd)

Jan 19 13:46:18 stein sd 88:0:0:0: [sdd] Attached SCSI disk
Jan 19 13:46:18 stein sd 88:0:0:0: Attached scsi generic sg3 type 14

  2.) start "dd if=/dev/sdd of=/dev/null"

  3.) switch on 2nd disk (sde)

Jan 19 13:48:11 stein firewire_sbp2: orb reply timed out, rcode=0x11
Jan 19 13:48:11 stein sd 88:0:0:0: [sdd] Result: hostbyte=DID_BUS_BUSY driverbyte=DRIVER_OK,SUGGEST_OK
Jan 19 13:48:11 stein end_request: I/O error, dev sdd, sector 7871464
Jan 19 13:48:11 stein Buffer I/O error on device sdd, logical block 983933
Jan 19 13:48:11 stein Buffer I/O error on device sdd, logical block 983934
Jan 19 13:48:11 stein Buffer I/O error on device sdd, logical block 983935
Jan 19 13:48:11 stein Buffer I/O error on device sdd, logical block 983936
Jan 19 13:48:11 stein Buffer I/O error on device sdd, logical block 983937
Jan 19 13:48:11 stein Buffer I/O error on device sdd, logical block 983938
Jan 19 13:48:11 stein Buffer I/O error on device sdd, logical block 983939
Jan 19 13:48:11 stein Buffer I/O error on device sdd, logical block 983940
Jan 19 13:48:11 stein Buffer I/O error on device sdd, logical block 983941
Jan 19 13:48:11 stein Buffer I/O error on device sdd, logical block 983942
Jan 19 13:48:11 stein sd 88:0:0:0: [sdd] Result: hostbyte=DID_BUS_BUSY driverbyte=DRIVER_OK,SUGGEST_OK
Jan 19 13:48:11 stein end_request: I/O error, dev sdd, sector 7871712
Jan 19 13:48:11 stein sd 88:0:0:0: [sdd] Result: hostbyte=DID_BUS_BUSY driverbyte=DRIVER_OK,SUGGEST_OK
Jan 19 13:48:11 stein end_request: I/O error, dev sdd, sector 7871720
Jan 19 13:48:11 stein sd 88:0:0:0: [sdd] Result: hostbyte=DID_BUS_BUSY driverbyte=DRIVER_OK,SUGGEST_OK
Jan 19 13:48:11 stein end_request: I/O error, dev sdd, sector 7871464
Jan 19 13:48:11 stein firewire_sbp2: error status: 0:9
Jan 19 13:48:11 stein firewire_sbp2: error status: 0:9
Jan 19 13:48:11 stein firewire_sbp2: error status: 0:9
Jan 19 13:48:12 stein firewire_sbp2: error status: 0:9
Jan 19 13:48:12 stein firewire_sbp2: error status: 0:9
Jan 19 13:48:12 stein firewire_sbp2: failed to reconnect to fw3.0
Jan 19 13:48:12 stein firewire_sbp2: logged in to fw3.0 LUN 0000 (0 retries)
Jan 19 13:48:26 stein firewire_sbp2: orb reply timed out, rcode=0x11
Jan 19 13:48:27 stein firewire_sbp2: error status: 0:9
Jan 19 13:48:27 stein firewire_sbp2: error status: 0:9
Jan 19 13:48:27 stein firewire_sbp2: error status: 0:9
Jan 19 13:48:27 stein scsi89 : SBP-2 IEEE-1394
Jan 19 13:48:27 stein firewire_core: created new fw device fw4 (6 config rom retries, S800)
Jan 19 13:48:27 stein firewire_sbp2: error status: 0:9
Jan 19 13:48:27 stein firewire_sbp2: logged in to fw4.0 LUN 0000 (0 retries)
Jan 19 13:48:27 stein scsi 89:0:0:0: Direct-Access-RBC HDS72404 0KLAT80          KFAO PQ: 0 ANSI: 4
Jan 19 13:48:27 stein sd 89:0:0:0: [sde] 1562845488 512-byte hardware sectors (800177 MB)
Jan 19 13:48:27 stein sd 89:0:0:0: [sde] Write Protect is off
Jan 19 13:48:27 stein sd 89:0:0:0: [sde] Mode Sense: 11 00 00 00
Jan 19 13:48:27 stein sd 89:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 19 13:48:27 stein sde: sde1
Jan 19 13:48:27 stein sd 89:0:0:0: [sde] Attached SCSI disk
Jan 19 13:48:27 stein sd 89:0:0:0: Attached scsi generic sg4 type 14
Jan 19 13:48:27 stein firewire_sbp2: error status: 0:9
Jan 19 13:48:27 stein firewire_sbp2: failed to reconnect to fw3.0
Jan 19 13:48:28 stein firewire_sbp2: logged in to fw3.0 LUN 0000 (0 retries)


Doing that, dd aborted:

dd: reading `/dev/sdd': Input/output error
7871464+0 records in
7871464+0 records out
4030189568 bytes (4.0 GB) copied, 57.6538 s, 69.9 MB/s

sdd was however accessible again after the login at 13:48:28.  As you
see, the SCSI stack did not take the disk offline after the I/O errors.
However, the desired behavior is that dd is simply put into I/O wait
state rather than failing with errors while the SBP-2 transport is busy.

Both disks used in this test are based on the OXFW912 bridge.  The
"error status: 0:9" before reconnect is typical for them, at least as I
have set them up right now (1394b card, 1394b hub, disks on the hub).
The status means "request complete, function rejected".  It has always
been recoverable here when I switched on the 2nd disk with the 1st disk
connected but idle.

Perhaps we should do it in fw-sbp2 like in sbp2:  Put the scsi_device
(in sbp2: the Scsi_Host) into blocked state between bus reset event and
successful reconnection.  We took a while to get this right in sbp2
because blocking the host is prone to deadlocks.  Therefore I was so far
satisfied with fw-sbp2 not using that scheme.

However, the first thing I shall try is to insert a "return
SCSI_MLQUEUE_HOST_BUSY" early in sbp2_scsi_queuecommand, depending on a
check of the logical unit's generation.

A variation of this problem is if the bus reset -- reconnect phase
happens while the SCSI stack is just in the middle of INQUIRY or READ
CAPACITY.  During this, the SCSI stack is very quick to offline a
device.  We need to do something there, because this situation is not
too unusual (e.g. when several FireWire devices are being powered up
together).

I will proceed to experiment with this as spare time permits.  Of course
any advice on how to best interact with the SCSI core while the
transport is busy would be appreciated.
-- 
Stefan Richter
-=====-==--- ---= =--==
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
