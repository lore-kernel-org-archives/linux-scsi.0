From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 2/2] ses: invalid free in ses_intf_remove_enclosure()
Date: Mon, 19 Oct 2015 13:16:18 +0300
Message-ID: <20151019101618.GB26688@mwanda>
References: <----An------QYmAn$4202951b-482d-4d92-98c2-3466de737b40@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19587 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbbJSKQj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2015 06:16:39 -0400
Content-Disposition: inline
In-Reply-To: <----An------QYmAn$4202951b-482d-4d92-98c2-3466de737b40@alibaba-inc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, =?utf-8?B?56iL5ZCbKOaIkOa3vCk=?= <chengmiao.cj@alibaba-inc.com>, security <security@kernel.org>, throber3 <throber3@gmail.com>

If thre aren't any components, then the component[0] is beyond the end
of the array.

Reported-by: "Berry Cheng =E7=A8=8B=E5=90=9B(=E6=88=90=E6=B7=BC)" <chen=
gmiao.cj@alibaba-inc.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index ff474c7..a31114d 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -780,7 +780,8 @@ static void ses_intf_remove_enclosure(struct scsi_d=
evice *sdev)
 	kfree(ses_dev->page2);
 	kfree(ses_dev);
=20
-	kfree(edev->component[0].scratch);
+	if (edev->components)
+		kfree(edev->component[0].scratch);
=20
 	put_device(&edev->edev);
 	enclosure_unregister(edev);
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
