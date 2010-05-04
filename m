From: Hannes Reinecke <hare@suse.de>
Subject: SYNCHRONIZE_CACHE command is not retried
Date: Tue, 04 May 2010 14:23:11 +0200
Message-ID: <4BE011AF.7010509@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab0EDMXM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 08:23:12 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id 0A4BF88B6C
	for <linux-scsi@vger.kernel.org>; Tue,  4 May 2010 14:23:12 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi all,

I'm facing an issue here where the 'SYNCHRONIZE CACHE' command is not r=
etried:

[  652.602637] sd 0:0:0:0: [sda] Send:=20
[  652.602640] sd 0:0:0:0: [sda] CDB: Synchronize Cache(10): 35 00 00 0=
0 00 00 00 00 00 00
[  652.604943] sd 0:0:0:0: [sda] Done: SUCCESS
[  652.604947] sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3D=
DRIVER_OK
[  652.604951] sd 0:0:0:0: [sda] CDB: Synchronize Cache(10): 35 00 00 0=
0 00 00 00 00 00 00
[  652.604958] sd 0:0:0:0: [sda] Sense Key : Unit Attention [current]=20
[  652.604962] sd 0:0:0:0: [sda] Add. Sense: Reported luns data has cha=
nged
[  652.604972] sd 0:0:0:0: [sda] Send:=20
[  652.604974] sd 0:0:0:0: [sda] CDB: Write(10): 2a 08 01 58 7b d6 00 0=
0 08 00
[  652.605176] sd 0:0:0:0: [sda] Done: SUCCESS
[  652.605179] sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3D=
DRIVER_OK
[  652.605182] sd 0:0:0:0: [sda] CDB: Write(10): 2a 08 01 58 7b d6 00 0=
0 08 00
[  652.605190] end_request: I/O error, dev sda, sector 22576086
[  652.605194] Buffer I/O error on device sda2, logical block 2295882
[  652.605196] lost page write due to I/O error on sda2
[  652.605207] Aborting journal on device sda2.

The 'SYNCHRONIZE CACHE' command is being inserted due to sd.c:

static void sd_prepare_flush(struct request_queue *q, struct request *r=
q)
{
	rq->cmd_type =3D REQ_TYPE_BLOCK_PC;
	rq->timeout =3D SD_TIMEOUT;
	rq->cmd[0] =3D SYNCHRONIZE_CACHE;
	rq->cmd_len =3D 10;
}

However, as the command type is set to REQ_TYPE_BLOCK_PC, the request i=
s
not retried from the SCSI midlayer, but rather passed back upwards.
'Upwards' here being the block layer, which has no truck with retrying.
Bad.
The same sense code is retried when it occurs during normal READ/WRITE
commands.
So it really would make sense to have it retried here, too.
Shouldn't the flush command being marked as 'REQ_TYPE_SPECIAL' here?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
