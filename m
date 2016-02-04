From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: What partition should the MTMKPART argument specify? Was: Re:
 st driver doesn't seem to grok LTO partitioning
Date: Thu, 4 Feb 2016 01:43:24 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB445262D4@G9W0766.americas.hpqcorp.net>
References: <20151218170644.24167419@harpe.intellique.com>
 <688812570.3359420.1452030904683.JavaMail.zimbra@redhat.com>
 <20160106161049.34f29973@harpe.intellique.com>
 <1993563395.3556606.1452093814452.JavaMail.zimbra@redhat.com>
 <20160106170720.61db9e86@harpe.intellique.com>
 <1371374871.6203837.1452802373256.JavaMail.zimbra@redhat.com>
 <DDB9C85B850785449757F9914A034FCB4450CE9B@G9W0766.americas.hpqcorp.net>
 <0840949A-970D-43FB-A691-E2F8AC2A0804@kolumbus.fi>
 <DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net>
 <alpine.LSU.2.11.1601242247440.3145@xnv.znxvfnen.cevingr>
 <DDB9C85B850785449757F9914A034FCB44522A7B@G9W0766.americas.hpqcorp.net>
 <6685EAA5-B880-40FB-951D-BA94883049B3@kolumbus.fi>
 <DDB9C85B850785449757F9914A034FCB44523469@G9W0766.americas.hpqcorp.net>
 <alpine.LSU.2.11.1601291915010.22105@xnv.znxvfnen.cevingr>
 <DDB9C85B850785449757F9914A034FCB44525667@G9W0766.americas.hpqcorp.net>
 <alpine.LSU.2.11.1602032011230.2679@xnv.znxvfnen.cevingr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t5009.houston.hp.com ([15.240.92.67]:46849 "EHLO
	g9t5009.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965028AbcBDBnr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2016 20:43:47 -0500
In-Reply-To: <alpine.LSU.2.11.1602032011230.2679@xnv.znxvfnen.cevingr>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Laurence Oberman <loberman@redhat.com>, Emmanuel Florac <eflorac@intellique.com>, Laurence Oberman <oberman.l@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Kai,

Tested with patched kernel 4.5.0-rc2-next-20160202+. It's looking good everything partition related passed with DDS5 and LTO6. You can definitely add me as a tested-by. I did find one issue below but it's not related to the partitioning changes.

# ./mt -f /dev/st0 stsetoption debug
# ./mt -f /dev/st0 stsetoption can-partitions
# ./mt -f /dev/st0 mkpartition 10000

[ 1871.160395] st 3:0:0:0: [st0] Block limits 1 - 16777215 bytes.
[ 1871.160955] st 3:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS 10, BLL 8
[ 1871.160958] st 3:0:0:0: [st0] Density 5a, tape length: 0, drv buffer: 1
[ 1871.160962] st 3:0:0:0: [st0] Block size: 0, buffer size: 4096 (1 blocks).
[ 1871.160963] st 3:0:0:0: [st0] Updating partition number in status.
[ 1871.161915] st 3:0:0:0: [st0] Got tape pos. blk 0 part 0.
[ 1871.161942] st 3:0:0:0: [st0] Loading tape.
[ 1871.176784] st 3:0:0:0: [st0] Block limits 1 - 16777215 bytes.
[ 1871.177284] st 3:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS 10, BLL 8
[ 1871.177289] st 3:0:0:0: [st0] Density 5a, tape length: 0, drv buffer: 1
[ 1871.177293] st 3:0:0:0: [st0] Block size: 0, buffer size: 4096 (1 blocks).
[ 1871.178632] st 3:0:0:0: [st0] Partition page length is 16 bytes.
[ 1871.178637] st 3:0:0:0: [st0] PP: max 3, add 1, xdp 1, psum 03, pofmetc 4, rec 03, units 09, sizes: 38 2543
[ 1871.178642] st 3:0:0:0: [st0] MP: 11 0e 03 01 3c 03 09 00 00 26 09 ef
[ 1871.178645] st 3:0:0:0: [st0] psd_cnt 2, max.parts 3, nbr_parts 1
[ 1871.178648] st 3:0:0:0: [st0] Formatting tape with two partitions (1 = 10000 MB).
[ 1871.178651] st 3:0:0:0: [st0] Sent partition page length is 12 bytes. needs_format: 1
[ 1871.178655] st 3:0:0:0: [st0] PP: max 3, add 1, xdp 1, psum 03, pofmetc 4, rec 03, units 09, sizes: 65535 10
[ 1871.178659] st 3:0:0:0: [st0] MP: 11 0a 03 01 3c 03 09 00 ff ff 00 0a
[ 1871.179655] st 3:0:0:0: [st0] Sending FORMAT MEDIUM
[ 1883.702742] st 3:0:0:0: [st0] Rewinding tape.

And we can change to partition 1 and back again. I ran this (I used the tell option but that failed more on that below):

# ./mt -f /dev/st0 setpartition 1
# ./mt -f /dev/st0 status
SCSI 2 tape drive:
File number=0, block number=0, partition=1.
Tape block size 0 bytes. Density code 0x5a (no translation).
Soft error count since last status=0
General status bits on (41010000):
 BOT ONLINE IM_REP_EN

Then wrote a tar archive to the drive and changed back to partition 0 and confirmed that I couldn't read the archive.

#  ./mt -f /dev/st0 mkpartition -10000

[ 3813.227898] st 3:0:0:0: [st0] Block limits 1 - 16777215 bytes.
[ 3813.228399] st 3:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS 10, BLL 8
[ 3813.228404] st 3:0:0:0: [st0] Density 5a, tape length: 0, drv buffer: 1
[ 3813.228408] st 3:0:0:0: [st0] Block size: 0, buffer size: 4096 (1 blocks).
[ 3813.228427] st 3:0:0:0: [st0] Loading tape.
[ 3813.242855] st 3:0:0:0: [st0] Block limits 1 - 16777215 bytes.
[ 3813.243304] st 3:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS 10, BLL 8
[ 3813.243310] st 3:0:0:0: [st0] Density 5a, tape length: 0, drv buffer: 1
[ 3813.243313] st 3:0:0:0: [st0] Block size: 0, buffer size: 4096 (1 blocks).
[ 3813.244552] st 3:0:0:0: [st0] Partition page length is 16 bytes.
[ 3813.244559] st 3:0:0:0: [st0] PP: max 3, add 1, xdp 1, psum 03, pofmetc 4, rec 03, units 09, sizes: 2543 38
[ 3813.244564] st 3:0:0:0: [st0] MP: 11 0e 03 01 3c 03 09 00 09 ef 00 26
[ 3813.244567] st 3:0:0:0: [st0] psd_cnt 2, max.parts 3, nbr_parts 1
[ 3813.244570] st 3:0:0:0: [st0] Formatting tape with two partitions (0 = 10000 MB).
[ 3813.244573] st 3:0:0:0: [st0] Sent partition page length is 12 bytes. needs_format: 1
[ 3813.244578] st 3:0:0:0: [st0] PP: max 3, add 1, xdp 1, psum 03, pofmetc 4, rec 03, units 09, sizes: 10 65535
[ 3813.244582] st 3:0:0:0: [st0] MP: 11 0a 03 01 3c 03 09 00 00 0a ff ff
[ 3813.245907] st 3:0:0:0: [st0] Sending FORMAT MEDIUM
[ 3821.916760] st 3:0:0:0: [st0] Rewinding tape.

That worked and I did the same tar test after changing partitions to make sure that I couldn't read it back after changing back to partition 0.

I retested the DDS5 drive it still works as expected.

I did find one issue in testing unrelated to the changes, the tell option didn't work with my LTO-6 drive:

# ./mt -f /dev/st0 tell
/dev/st0: Input/output error

[ 2045.974642] st 3:0:0:0: [st0] Block limits 1 - 16777215 bytes.
[ 2045.975221] st 3:0:0:0: [st0] Mode sense. Length 11, medium 0, WBS 10, BLL 8
[ 2045.975224] st 3:0:0:0: [st0] Density 5a, tape length: 0, drv buffer: 1
[ 2045.975226] st 3:0:0:0: [st0] Block size: 0, buffer size: 4096 (1 blocks).
[ 2045.975718] st 3:0:0:0: [st0] Error: 8000002, cmd: 34 1 0 0 0 0
[ 2045.975723] st 3:0:0:0: [st0] Sense Key : Illegal Request [current]
[ 2045.975726] st 3:0:0:0: [st0] Add. Sense: Invalid field in cdb
[ 2045.975729] st 3:0:0:0: [st0]  Can't read tape position.
[ 2045.975857] st 3:0:0:0: [st0] Rewinding tape.

I believe that in get_location() we're doing this:

static int get_location(struct scsi_tape *STp, unsigned int *block, int *partition,
                        int logical)
{
        int result;
        unsigned char scmd[MAX_COMMAND_SIZE];
        struct st_request *SRpnt;

        if (STp->ready != ST_READY)
                return (-EIO);

        memset(scmd, 0, MAX_COMMAND_SIZE);
        if ((STp->device)->scsi_level < SCSI_2) {
                scmd[0] = QFA_REQUEST_BLOCK;
                scmd[4] = 3;
        } else {
                scmd[0] = READ_POSITION;
                if (!logical && !STp->scsi2_logical)
                        scmd[1] = 1; <<<<<<<<<<<<<<
        }

When called from the ioctl that the tell option uses the variable logical is passed in as 0 (from what I could see everything else sets it to 1). For a READ_POSITION the drive I'm using only supports 0, 6, or 8 in the service action field of the second byte:

https://docs.oracle.com/cd/E38452_01/en/LTO6_Vol3_E1_D20/LTO6_Vol3_E1_D20.pdf

For SSC-3 (e.g. http://www.13thmonkey.org/documentation/SCSI/ssc3r01c.pdf) it looks like service action 1 is vendor specific and optional so it may not be implemented. SSC-2 defines that bit separately (http://www.staff.uni-mainz.de/tacke/scsi/SCSI2-10.html) as "A block address type (BT) bit of one requests the target to return its current first block location and last block location as a device-specific value.". 

It may need a test on scsi3 like in partition_tape so it would look like:

static int get_location(struct scsi_tape *STp, unsigned int *block, int *partition,
                        int logical)
{
        int result;
        unsigned char scmd[MAX_COMMAND_SIZE];
        struct st_request *SRpnt;
+	bool scsi3 = STp->device->scsi_level >= SCSI_3;

        if (STp->ready != ST_READY)
                return (-EIO);

        memset(scmd, 0, MAX_COMMAND_SIZE);
        if ((STp->device)->scsi_level < SCSI_2) {
                scmd[0] = QFA_REQUEST_BLOCK;
                scmd[4] = 3;
        } else {
                scmd[0] = READ_POSITION;
-               if (!logical && !STp->scsi2_logical)
+               if (!logical && !STp->scsi2_logical && !scsi3)
                        scmd[1] = 1;
        }

If you're fine with that and you don't believe it will have any side effects I can post a patch for that.

Thanks
Shane
