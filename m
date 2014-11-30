From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 0/4] remove unneeded array
Date: Sun, 30 Nov 2014 19:14:11 +0100
Message-ID: <1417371255-2282-1-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: devel@driverdev.osuosl.org
Cc: sparmaintainer@unisys.com, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove an array or structure that only serves as the first argument to
memset.  The complete semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
type T;
@@

{
... when any
-T x[...];
<+... when != x
- memset(x,...);
...+>
}

@@
identifier x,i;
@@

{
... when any
-struct i x;
<+... when != x
- memset(&x,...);
...+>
}
// </smpl>
