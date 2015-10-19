From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 106251] New: there exists a wrong return value of function
 iscsi_if_recv_msg() when iscsi_lookup_endpoint() fails
Date: Mon, 19 Oct 2015 14:17:48 +0000
Message-ID: <bug-106251-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40865 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbbJSORw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2015 10:17:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6331A20784
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2015 14:17:51 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0F225206F4
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2015 14:17:49 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D106251

            Bug ID: 106251
           Summary: there exists a wrong return value of function
                    iscsi_if_recv_msg() when iscsi_lookup_endpoint() fa=
ils
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.2
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: rucsoftsec@gmail.com
        Regression: No

In function iscsi_if_recv_msg() at drivers/scsi/scsi_transport_iscsi.c:=
3491,
the call to iscsi_lookup_endpoint() in line 3575 may fail, and thus fun=
ction
iscsi_if_recv_msg() will return the value of variable 'err'. And, the f=
unction
iscsi_if_recv_msg() will return 0 at last when it runs well. So the fun=
ction
iscsi_if_recv_msg() will return 0 to its caller functions when it runs =
error
because of the failing call to iscsi_lookup_endpoint(), leading to a wr=
ong
return value in function iscsi_if_recv_msg().
The related code snippets in iscsi_if_recv_msg() are as following.
iscsi_if_recv_msg @@ drivers/scsi/scsi_transport_iscsi.c:3491
3491 static int
3492 iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint3=
2_t
*group)
3493 {
3494         int err =3D 0;
                     ......
3575                 ep =3D iscsi_lookup_endpoint(ev->u.b_conn.transpor=
t_eph);
3576                 if (ep) {
3577                         ep->conn =3D conn;
3578=20
3579                         mutex_lock(&conn->ep_mutex);
3580                         conn->ep =3D ep;
3581                         mutex_unlock(&conn->ep_mutex);
3582                 } else
3583                         iscsi_cls_conn_printk(KERN_ERR, conn,
3584                                               "Could not set ep co=
nn "
3585                                               "binding\n");
3586                 break;
                     ......
3679         return err;
3680 }


Generally, the return value of caller functions which call function
iscsi_lookup_endpoint() shall be set to a negative number when the call=
 to
iscsi_lookup_endpoint() fails, like the following codes in another file=
=2E
beiscsi_conn_bind @@ drivers/scsi/be2iscsi/be_iscsi.c=EF=BC=9A195
195 int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
196                       struct iscsi_cls_conn *cls_conn,
197                       u64 transport_fd, int is_leading)
198 {
            ......
208         ep =3D iscsi_lookup_endpoint(transport_fd);
209         if (!ep)
210                 return -EINVAL;
            ......
238 }

Thank you

RUC_Soft_Sec

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
