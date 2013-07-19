From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH v4 1/4] [SCSI] sg: use rwsem to solve race during
 exclusive open
Date: Fri, 19 Jul 2013 17:19:01 -0400
Message-ID: <20130719211901.GA29404@logfs.org>
References: <20130715203730.GA21804@logfs.org>
 <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
 <1374075246-22923-2-git-send-email-vaughan.cao@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59822 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab3GSWul (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jul 2013 18:50:41 -0400
Content-Disposition: inline
In-Reply-To: <1374075246-22923-2-git-send-email-vaughan.cao@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 17 July 2013 23:34:03 +0800, Vaughan Cao wrote:
> Date: Wed, 17 Jul 2013 23:34:03 +0800
> From: Vaughan Cao <vaughan.cao@oracle.com>
> To: joern@logfs.org
> Cc: dgilbert@interlog.com, JBottomley@parallels.com,
> 	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
> 	vaughan.cao@oracle.com
> Subject: [PATCH v4 1/4] [SCSI] sg: use rwsem to solve race during
>  exclusive open
> X-Mailer: git-send-email 1.7.11.7
>=20
> A race condition may happen if two threads are both trying to open th=
e same sg
> with O_EXCL simultaneously. It's possible that they both find fsds li=
st is
> empty and get_exclude(sdp) returns 0, then they both call set_exclude=
() and
> break out from wait_event_interruptible and resume open.
>=20
> Now use rwsem to protect this process. Exclusive open gets write lock=
 and
> others get read lock. The lock will be held until file descriptor is =
closed.
> This also leads 'exclude' only a status rather than a check mark.
>=20
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
Reviewed-by: Joern Engel <joern@logfs.org>

J=C3=B6rn

--
When you close your hand, you own nothing. When you open it up, you
own the whole world.
-- Li Mu Bai in Tiger & Dragon
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
