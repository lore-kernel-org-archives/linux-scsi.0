From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/2] libata: Remove dependence on host_set->dev for SAS
Date: Tue, 29 Nov 2005 16:13:10 -0600
Message-ID: <438CD276.5030007@us.ibm.com>
References: <4341A91A.3020000@us.ibm.com> <434251E0.9060000@pobox.com>	 <58cb370e0510040322q1cb7a13bjfc6c7875140d20a9@mail.gmail.com> <58cb370e0510041356h780e7a5aifda0c232f677471e@mail.gmail.com> <43443E99.4090008@pobox.com> <435D5D83.1060201@us.ibm.com> <435D5DE5.7010306@us.ibm.com> <435E7105.4010105@pobox.com> <435E87E8.9010506@us.ibm.com> <435E8AC7.1080407@pobox.com> <435EB656.1040502@adaptec.com> <4360FAC1.8020409@us.ibm.com> <43850F0D.7040907@torque.net>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43850F0D.7040907@torque.net>
Sender: linux-ide-owner@vger.kernel.org
To: dougg@torque.net
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Jeff Garzik <jgarzik@pobox.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, t.schorpp@gmx.de
List-Id: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Brian King wrote:
>> I think you really need a
>> libata API that the LLDD can call from its queuecommand function
>> to translate and send a command, which then calls back into the LLDD
>> to send the FIS to the hardware. This allows for all SAS/SATA devices
>> under the same HBA to show up under the same scsi_host.
> 
> Brian,
> I don't think a SATL is that easy. 

That is essentially the API that libata has today. Existing SATA drivers
have a queuecommand routine that invokes a libata API to send a taskfile
to the hardware.

> One SCSI command can
> translate into zero or more ATA commands. If it translates
> to multiple commands, then there is the possibility of an
> error prior to the last in the sequence of ATA commands
> (how to report; rollback needed ?). The SATL needs to hold
> state and needs a service thread if it is to support the
> IMMED bit on some commands (e.g. START STOP UNIT).

I guess I don't see these problems as unique to SATA drives attached
via a SAS adapter, which is what my patchset is trying to implement,
but rather general libata issues. Reading Jeff's response, it sounds
like the service thread issue is already being worked in another manner.


Brian


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

