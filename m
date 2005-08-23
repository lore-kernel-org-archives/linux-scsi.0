From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] libata: error processing + rw 6 byte fix
Date: Tue, 23 Aug 2005 22:14:47 +1000
Message-ID: <430B1337.7080906@torque.net>
References: <430994BC.4060102@torque.net> <430A230B.8040204@pobox.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <430A230B.8040204@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Douglas Gilbert wrote:
> 
>> This is a revised patch following this post:
>> http://marc.theaimsgroup.com/?l=linux-scsi&m=112461881419898&w=2
>>
>> The plan is to add MODE SELECT SCSI command support to
>> libata so that parameters such as WCE and DRA can be
>> changed by a user (i.e. Write(back) Cache Enable and
>> Disable Read Ahead respectively). There are still some
>> issues to be addressed with MODE SELECT so the attached
>> is mainly a subset of the earlier one.
>> It improves error processing and fixes a READ_6/WRITE_6
>> SCSI command special case ** as requested by Jeff G.
>>
>> The attached is against lk 2.6.13-rc6 and includes the
>> START STOP UNIT patch.
>>
>> ChangeLog:
>>    - generalize SCSI error processing
>>    - add block descriptor to MODE SENSE command
>>    - make various changes to sync with sat-r05 (as
>>      noted in source)
>>    - fix READ(6) and WRITE(6) SCSI command special
>>      case: transfer_length=0 -> transfer 256 blocks
>>
>>
>> ** The special case can be tested with sg_dd:
>> sg_dd if=/dev/sda blk_sgio=1 cdbsz=6 of=. bs=512 bpt=256 count=256
>>    This tests READ(6) with a transfer length of 0
>>    (i.e. 256 blocks) in its cdb.
>>    BTW the scsi_debug driver has the same bug.
>>
>> Signed-off-by: Douglas Gilbert <dougg@torque.net>
> 
> 
> First change needed:  this patch must be incremental to your previous
> START STOP UNIT patch, since I have already applied that patch.

ok

>> @@ -579,7 +631,19 @@
>>      }
>>  
>>      if (scsicmd[0] == READ_6 || scsicmd[0] == WRITE_6) {
>> -        qc->nsect = tf->nsect = scsicmd[4];
>> +        if (scsicmd[4] == 0) {
>> +            /*
>> +             * For READ_6 and WRITE_6 (only)
>> +             * transfer_len==0 -> 256 blocks !!
>> +             */
>> +            if (lba48) {
>> +                tf->hob_nsect = 1;
>> +                qc->nsect = 256;
>> +            } else
>> +                return 1;
>> +        } else
>> +            qc->nsect = scsicmd[4];
>> +        tf->nsect = scsicmd[4];
>>          tf->lbal = scsicmd[3];
>>          tf->lbam = scsicmd[2];
>>          tf->lbah = scsicmd[1] & 0x1f; /* mask out reserved bits */
> 
> 
> lba28 ATA commands behave similarly:  for READ DMA, which only has an
> 8-bit sector count, 00h == 256 sectors.
> 
> So, you should not error out for that case.

For READ_6 and WRITE_6 is this correct:

       if (scsicmd[4] == 0) {
           /*
            * For READ_6 and WRITE_6 (only)
            * transfer_len==0 -> 256 blocks !!
            */
           qc->nsect = 256;
       } else
           qc->nsect = scsicmd[4];
       tf->nsect = scsicmd[4];

> 
> 
>> @@ -1027,6 +1121,13 @@
>>      return sizeof(page);
>>  }
>>  
>> +/* As of sat-r05: considering defining this page (for QErr).
>> + * D_SENSE is now 0 (fixed sense data format);
>> + * guess extended self test completion time: 30 seconds (why?).
>> + */
>> +static const u8 def_control_mpage[] = {
>> +        0xa, 0xa, 0, 0, 0, 0, 0, 0, 0xff, 0xff, 0, 30};
>> +
>>  /**
>>   *    ata_msense_ctl_mode - Simulate MODE SENSE control mode page
>>   *    @dev: Device associated with this MODE SENSE command
>> @@ -1041,16 +1142,17 @@
>>  
>>  static unsigned int ata_msense_ctl_mode(u8 **ptr_io, const u8 *last)
>>  {
>> -    const u8 page[] = {0xa, 0xa, 6, 0, 0, 0, 0, 0, 0xff, 0xff, 0, 30};
>> -
>> -    /* byte 2: set the descriptor format sense data bit (bit 2)
>> -     * since we need to support returning this format for SAT
>> -     * commands and any SCSI commands against a 48b LBA device.
>> -     */
>> -
>> -    ata_msense_push(ptr_io, last, page, sizeof(page));
>> -    return sizeof(page);
>> +    ata_msense_push(ptr_io, last, def_control_mpage,
>> +            sizeof(def_control_mpage));
>> +    return sizeof(def_control_mpage);
>>  }
>> +   
> 
> 
> Please don't shuffle code around, AND change it at the same time.  It
> has the effect of hiding small changes.
> 
> In this case, you have chosen to clear the D_SENSE bit (ok) and the
> GLTSD bit (not ok).

Global Logging Target Save Disable (GLTSD) impacts information
accessed by LOG SENSE and LOG SELECT which are not currently
supported by libata (although SAT defines support for them).
smartctl when applied to SCSI disks looks at the GLTSD bit
and warns the user when the bit is set (suggesting he clears
it). That would be futile in the case of libata currently.
SAT doesn't give guidance for the control mode page (yet).

And the shuffle is to make the default setting of the mode
page visible to MODE SELECT code [which is not yet present].

>> +static const u8 def_rw_recovery_mpage[] = {
>> +        0x1,              /* page code */
>> +        0xa,              /* page length */
>> +        (1 << 6),          /* note: ARRE=1 */
>> +        0, 0, 0, 0, 0, 0, 0, 0, 0 /* 9 zeroes */
>> +    };    /* sat-r05 says AWRE will be 0 */
>>  
>>  /**
>>   *    ata_msense_rw_recovery - Simulate MODE SENSE r/w error recovery
>> page
>> @@ -1066,15 +1168,9 @@
>>  
>>  static unsigned int ata_msense_rw_recovery(u8 **ptr_io, const u8 *last)
>>  {
>> -    const u8 page[] = {
>> -        0x1,              /* page code */
>> -        0xa,              /* page length */
>> -        (1 << 7) | (1 << 6),      /* note auto r/w reallocation */
>> -        0, 0, 0, 0, 0, 0, 0, 0, 0 /* 9 zeroes */
>> -    };
>> -
>> -    ata_msense_push(ptr_io, last, page, sizeof(page));
>> -    return sizeof(page);
>> +    ata_msense_push(ptr_io, last, def_rw_recovery_mpage,
>> +            sizeof(def_rw_recovery_mpage));
>> +    return sizeof(def_rw_recovery_mpage);
>>  }
>>  
>>  /**
> 
> 
> Similarly, do not clear bits without discussion.
> 
> In this case, I disagree with SAT.  ATA devices will definitely
> reallocate around defective sectors in the background, trying its
> damndest to complete a write without failing.
> 
> Reads are obviously different.  The device doesn't known, until the OS
> asks for a sector, whether its corrupt or not.  The device is free to
> reallocate this sector as well, in the background, once it discovers
> that a sector is defective.
> 
> How to interpret this?  Re-reading SBC-2, it is my feeling that ATA
> devices should either set both AWRE and ARRE since they do perform
> background reallocation, or, set NEITHER bit, since the libata SAT layer
> does not support the error reporting bits mentioned in SBC-2 for R/W
> Recovery Page.
> 
> As of the current implementation, I made a conscious decision to ignore
> SAT and set both bits.  I'm willing to consider changing to the 'neither
> bit' setup, but not one where ARRE is the only bit set.

I have no strong opinion and was following sat-r05.

>> @@ -1093,28 +1189,54 @@
>>                    unsigned int buflen)
>>  {
>>      u8 *scsicmd = args->cmd->cmnd, *p, *last;
>> -    unsigned int page_control, six_byte, output_len;
>> +    const u8 sat_blk_desc[] = {0, 0, 0, 0, 0, 0, 0x2, 0x0};
>> +    /* 512 byte blocks, number of blocks = 0, (sat-r05) */
> 
> 
> NOTE: don't hardcode 512, since that will change very soon in SATA.

So put ATA_SECT_SIZE in there for the time being?
BTW sat-r05 is inconsistent in what should be
placed in the "Number of Blocks" field which I
have asked the sat maintainer to resolve.

> 1K ATA devices are just around the corner.
> 
>> @@ -1570,11 +1737,6 @@
>>              ata_scsi_rbuf_fill(&args, ata_scsiop_mode_sense);
>>              break;
>>  
>> -        case MODE_SELECT:    /* unconditionally return */
>> -        case MODE_SELECT_10:    /* bad-field-in-cdb */
>> -            ata_bad_cdb(cmd, done);
>> -            break;
>> -
>>          case READ_CAPACITY:
>>              ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
>>              break;
> 
> 
> At this point in the patch series, you should not be removing this code
> AFAICS.

It is a trick and an error correction. In this version
of libata MODE SELECT commands don't have "invalid field
in cdb" as the ata_bad_cmd() sets, but "invalid command
operation code" which is what the default case sets.
Perhaps that should be made clearer by removing the
drop through. OTOH all unsupported commands drop
through to the default case.

> Finally, overall, it would really be nice if you would split your
> changes into a series of patches.  i.e.
> 
> [PATCH 1/4] START STOP UNIT (already applied)
> [PATCH 2/4] ata_scsi_set_sense() impl, and usage
> [PATCH 3/4] twiddle mode parameter page values
> [PATCH 4/4] MODE SENSE cleanup, blk descriptor, move mode page values
> etc.
> 
> I don't mean to carp, but separating out changes in this manner is
> strongly encouraged under Linux, and greatly aids in reviewing and
> applying each patch.  You don't have to enumerate EVERY change into a
> separate patch, just be reasonable:  group sets of associated changes
> into patches.

Doug Gilbert


