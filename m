From: Laurie Costello <lmcostello@yahoo.com>
Subject: non-zero result with NO_SENSE
Date: Thu, 2 Nov 2006 06:28:59 -0800 (PST)
Message-ID: <20061102142859.93227.qmail@web31007.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31007.mail.mud.yahoo.com ([68.142.200.170]:35425 "HELO
	web31007.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750714AbWKBO3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Nov 2006 09:29:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm researching a problem with data corruption on linux 2.6.9.

I'm seeing results of scsi_print_sense() in the system log, which brought me

to this chunk of code.  Is it correct to process a non-zero result with

NO_SENSE as if an error didn't occur or was recovered?



Laurie Costello





Oct  9 08:16:03 localhost kernel: Info fld=0x0, Current sdv: sense key No Sense



        /* An error occurred */

        if (driver_byte(result) != 0 &&         /* An error occurred */

            (SCpnt->sense_buffer[0] & 0x7f) == 0x70) { /* Sense current */

                switch (SCpnt->sense_buffer[2]) {

 ......deleted some case statement code



                case RECOVERED_ERROR: /* an error occurred, but it recovered */

                case NO_SENSE: /* LLDD got sense data */

                        /*

                         * Inform the user, but make sure that it's not treated

                         * as a hard error.

                         */

                        scsi_print_sense("sd", SCpnt);

                        SCpnt->result = 0;

                        SCpnt->sense_buffer[0] = 0x0;
                       good_bytes = this_count;

                        break;




