From: christophe.varoqui@free.fr
Subject: Re: [sg3_utils] report target group
Date: Thu, 30 Dec 2004 15:00:33 +0100
Message-ID: <1104415233.41d40a018c287@imp5-q.free.fr>
References: <1104233396.41d143b44e073@imp5-q.free.fr> <41D21DDD.5010109@torque.net> <1104307397.41d264c5c5d3c@imp5-q.free.fr> <41D2AF42.5050007@torque.net> <1104327781.41d2b4654846d@imp5-q.free.fr> <41D38DBF.6010303@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix3-1.free.fr ([213.228.0.44]:52431 "EHLO
	postfix3-1.free.fr") by vger.kernel.org with ESMTP id S261625AbUL3OAe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Dec 2004 09:00:34 -0500
In-Reply-To: <41D38DBF.6010303@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Selon Douglas Gilbert <dougg@torque.net>:

> christophe.varoqui@free.fr wrote:
> > Very nice.
> >
> > May you should consider this small incremental
> > And rename the file to sg_rtpg.c
> >
> > ... for coherency.
>
> Done and uploaded.
>
Do you think it is possible to deduce a "server-side target number" from the
"Relative target port ids" fields reported by RTPG ?

Let's say I have /dev/sda as 0:0:0:1.

# ./sg_rtg -d /dev/sda
Report list length = 32
Report target groups:
  target port group id : 0x1 , Pref=1
    target port group assymetric access state : 0x00 (active/optimized)
    U_SUP : 0, S_SUP : 0, AN_SUP : 1, AO_SUP : 1
    status code : 0x02 (status changed by implicit TPGS behaviour)
    vendor unique status : 0x00
    target port count : 02
    Relative target port ids:
      0x01
      0x02
  target port group id : 0x2 , Pref=0
    target port group assymetric access state : 0x01 (active/non optimized)
    U_SUP : 0, S_SUP : 0, AN_SUP : 1, AO_SUP : 1
    status code : 0x00 (no status available)
    vendor unique status : 0x00
    target port count : 01
    Relative target port ids:
      0x03

I can see no way to guess that 0:0:x:1 is path to the same LU through another
port of the same "target port group" ...

Or can we assume that ?
target port WWPN = WWNN + Relative target port id

At least it seems to be the case on StorageWorks controlers (well, they do not
support the TPGS spec though) :

lpfc1t00 DID 0a0100 WWPN 50:00:1f:e1:00:0b:da:d1 WWNN 50:00:1f:e1:00:0b:da:d0
lpfc1t01 DID 0a0300 WWPN 50:00:1f:e1:00:0b:da:d2 WWNN 50:00:1f:e1:00:0b:da:d0
lpfc1t02 DID 0a0400 WWPN 50:00:1f:e1:00:0b:da:d3 WWNN 50:00:1f:e1:00:0b:da:d0
lpfc1t03 DID 0a0600 WWPN 50:00:1f:e1:00:0b:da:d4 WWNN 50:00:1f:e1:00:0b:da:d0

All in all, I don't really see how one can use the result of RTPG.
Insights ?

regards,
cvaroqui
--
