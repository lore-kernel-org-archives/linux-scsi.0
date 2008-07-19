From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: persistent reservation behaviour with dm-multipath
Date: Sat, 19 Jul 2008 10:59:52 +0200
Message-ID: <1216457992.7364.15.camel@plop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix2-g20.free.fr ([212.27.60.43]:39924 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbYGSJBZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Jul 2008 05:01:25 -0400
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by postfix2-g20.free.fr (Postfix) with ESMTP id 6DD8E2830DC9
	for <linux-scsi@vger.kernel.org>; Sat, 19 Jul 2008 09:01:06 +0200 (CEST)
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by smtp7-g19.free.fr (Postfix) with ESMTP id 93FB1322815
	for <linux-scsi@vger.kernel.org>; Sat, 19 Jul 2008 10:59:52 +0200 (CEST)
Received: from [192.168.0.105] (chn60-1-82-233-48-227.fbx.proxad.net [82.233.48.227])
	by smtp7-g19.free.fr (Postfix) with ESMTP id 5DF02322803
	for <linux-scsi@vger.kernel.org>; Sat, 19 Jul 2008 10:59:52 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The current dm-multipath behaviour is currently a potent data corrupter
on Persistant Reservation-based clusters sharing multipaths with the
queue_if_no_path feature on (Clariion, Storageworks, ...).

Consider the following scenario :

- Node A take a write-exclusive persistent reservation on LU
- Node B submits a write io to LU, which is a sda-sdb multipath
=EF=BB=BF- B dm_multipath routes the wio to sda, the wio is failed, the=
 path is
marked failed
=EF=BB=BF- B dm_multipath routes the wio to sdb, the wio is failed, the=
 last
path is marked failed
- B queues the wio because of the queue_if_no_path feature. Process
submitting the wio is stuck in D-state.
- A releases the reservation. Queued wios are unqueued, corrupting the
data on LU.

I suspect wio returning a "reservation conflict" status should never be
queued.

DM suspend/resume on the multipath devmap effectively flushes the queue=
,
but this solution leaves a window open for data corruption, between io
enqueue and user-space driven queue flush.

Is there work in progress to address this issue yet ? What's would be a=
n
acceptable solution design (for example Mike Christie suggested in Aug
2005 a scsi-to-blk error translation patch, which got nowhere) ?

Regards,
cvaroqui

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
