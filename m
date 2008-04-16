From: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Subject: Re: aic94xx + ST3146855SS still failing under heavy load
Date: Wed, 16 Apr 2008 18:46:36 +0200
Message-ID: <48062D6C.6070807@ipax.at>
References: <1208192617.10361.18.camel@lvk-nb.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ipax.at ([80.64.143.40]:37472 "EHLO mail.ipax.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759713AbYDPQqi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Apr 2008 12:46:38 -0400
In-Reply-To: <1208192617.10361.18.camel@lvk-nb.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Leonid Kalmankin <lvk@mashcenter.ru>
Cc: linux-scsi@vger.kernel.org

hi,

some others, like me, are struggeling with this problem.
afaik, james bottomley (or someone else?) is working on a fix,
but it will take some more time.

please see [1] and [2].

btw. i asked seagate and adaptec and both did not come up with a decent
solution. seagate asked me to verify this with a different controller
and said that they know of no issue and adaptec gave me a new sequencer
firmware - so at least the server is still responding properly - and
told me that all the fixes went into the recent 2.6.25rc6+ kernel.

cheers,
raoul
[1] http://marc.info/?t=120603924200004
[2] http://marc.info/?t=120757821700007

Leonid Kalmankin wrote:
> Hello!
> 
> We have a system with:
> 
> vanilla 2.6.25-rc8 (2.6.23, 2.6.24 have the same behaviour)
> 
> Adaptec AIC-9410W SAS (Razor ASIC RAID) (rev 09)
> aic94xx: Found sequencer Firmware version 1.1 (V30)
>   (Firmware version 1.1 (V17/10c6) makes no difference)
> scsi 2:0:0:0: Direct-Access  SEAGATE ST3146855SS 0002 PQ: 0 ANSI: 5
> 
> 
> It reliably fails under heavy IO:
> 
>> sas: command 0xffff81022c5f5640, task 0xffff8101f6b0f000, timed out: EH_NOT_HANDLED
>> sas: command 0xffff81022c5f5500, task 0xffff8101f6b0f1c0, timed out: EH_NOT_HANDLED
>> ....
>> sas: Enter sas_scsi_recover_host
>> sas: trying to find task 0xffff8101f6b0f000
>> sas: sas_scsi_find_task: aborting task 0xffff8101f6b0f000
>> aic94xx: task 0xffff8101f6b0f000 done with opcode 0x1e resp 0x0 stat 0x8d but aborted by upper layer!
>> aic94xx: tmf tasklet complete
>> aic94xx: tmf came back
>> aic94xx: asd_abort_task: task 0xffff8101f6b0f000 done
>> aic94xx: task 0xffff8101f6b0f000 aborted, res: 0x0
>> sas: sas_scsi_find_task: task 0xffff8101f6b0f000 is done
>> sas: sas_eh_handle_sas_errors: task 0xffff8101f6b0f000 is done
>> sas: --- Exit sas_scsi_recover_host
> 
> Sometimes it successfully recovers; sometimes the disk is lost until the reboot.
> 
> I've read http://archive.netbsd.se/?ml=linux-scsi&a=2008-01&t=6260524
> Asked Seagate about firmware update; they told me they do not have any.
> 
> As I understood, the root of this problem is protocol errors in disk's firmware
> (other disks, for example FUJITSU MBA3147RC work fine); however, that kind of errors
> should be recoverable by sas/aic94xx drivers.
> 
> If that is true, I could test some patches/ideas, where should I start?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
____________________________________________________________________
DI (FH) Raoul Bhatia M.Sc.          email.          r.bhatia@ipax.at
Technischer Leiter

IPAX - Aloy Bhatia Hava OEG         web.          http://www.ipax.at
Barawitzkagasse 10/2/2/11           email.            office@ipax.at
1190 Wien                           tel.               +43 1 3670030
FN 277995t HG Wien                  fax.            +43 1 3670030 15
____________________________________________________________________
