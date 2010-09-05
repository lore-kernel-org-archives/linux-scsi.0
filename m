From: Douglas Gilbert <dgilbert@interlog.com>
Subject: libata: SATL error processing: unrecovered read error
Date: Sun, 05 Sep 2010 11:57:16 -0400
Message-ID: <4C83BDDC.3020201@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

While looking at an eSATA connected external disk with
a medium error, this sense data appeared:

     READ cdb: 28 00 96 4a 7a d1 00 00 01 00
       duration=2816 ms
READ:  Descriptor format, current;  Sense key: Medium Error
  Additional sense: Unrecovered read error - auto reallocate failed
   Descriptor type: Information
     0x00000000964a7ad1
  Raw sense data (in hex):
         72 03 11 04 00 00 00 0c  00 0a 80 00 00 00 00 00
         96 4a 7a d1

That is pretty close to what I was expecting to see. If anything
there is too much information. That "Unrecovered read error -
auto reallocate failed" [asc/asq: 11h/04h] should just be
"Unrecovered read error" [asc/asq: 11h/0h]. See sat2r09.pdf table
105 or sat3r00.pdf table 105.

The problem seems to be in libata's SATL code in the sense_table[]
in ata_to_sense_error() in libata-scsi.c . Looks like some other
entries in that sense_table need adjusting as well to align them
to SAT's table 105.

Also it is good to have a reference comment as sense_data[]
does in lk 2.6.35:
   /* Based on the 3ware driver translation table */

but this would be better (if it did comply):
   /* Based on table 105 in SAT-2 rev 9 */

Doug Gilbert
