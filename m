Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D225EC33CA7
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 00:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FCE12071A
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 00:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731721AbgALAW4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jan 2020 19:22:56 -0500
Received: from mail3.iservicesmail.com ([217.130.24.75]:54294 "EHLO
        mail3.iservicesmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731719AbgALAW4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jan 2020 19:22:56 -0500
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Jan 2020 19:22:55 EST
IronPort-SDR: 1KaHSgWylmb0hXMR6K0CgtiEwi3u0JPU4HFgGMks92PwL2cjkTD8EizuxWwto6pAKt9ojVlZEh
 HHn6HiExV3Hg==
IronPort-PHdr: =?us-ascii?q?9a23=3AdTxlLRWC9z5DBniogwJnZXm2rjTV8LGtZVwlr6?=
 =?us-ascii?q?E/grcLSJyIuqrYbB2Ht8tkgFKBZ4jH8fUM07OQ7/m7HzZev93Y4TgrS99lb1?=
 =?us-ascii?q?c9k8IYnggtUoauKHbQC7rUVRE8B9lIT1R//nu2YgB/Ecf6YEDO8DXptWZBUh?=
 =?us-ascii?q?rwOhBoKevrB4Xck9q41/yo+53Ufg5EmCexbal9IRmrowjdrNcajIpjJ6o+1x?=
 =?us-ascii?q?fEpmZDdvhLy29vOV+dhQv36N2q/J5k/SRQuvYh+NBFXK7nYak2TqFWASo/PW?=
 =?us-ascii?q?wt68LlqRfMTQ2U5nsBSWoWiQZHAxLE7B7hQJj8tDbxu/dn1ymbOc32Sq00WS?=
 =?us-ascii?q?in4qx2RhLklDsLOjgk+23RjcB+kb5Urwikpx1/2oLZfoaVNOBmfqPaZ9MVX3?=
 =?us-ascii?q?ZBUdhIWyNfBIOwdpcCD/YdPelCs4b9p0UBrR6gCgmqGOPj0yFHhnnv0aM91O?=
 =?us-ascii?q?QhFx/J3Qw5E90QtnTfsdH5OakOXeypyaXFyyjIYfFL1jfn8IXGfBAvoeuSU7?=
 =?us-ascii?q?xzbMTexlUgGQzeg1WMq4HqIy+Z2vgRv2SF6edrSOKhi3QgqwF0ujWh3Nkjip?=
 =?us-ascii?q?XXiYIP11vL9SJ5wIA6JdalT0N7ecCrEIdOuCGAOYp2RcUiQ25ztSY60b0Joo?=
 =?us-ascii?q?K0cDIWx5Qgwh7TcfyHc4uR7x/lSe2fIi94iWp7dL6ihRu+61Wsx+PgWsWuzl?=
 =?us-ascii?q?pHoTBJn9fMu30Lyhfd8NKISuFn8UekwTuP0gfT5fxaLk0sjqrbLoIhwqY3lp?=
 =?us-ascii?q?oOrUTPBi/2l1vyjK+Rbkgk//Kn6+XjYrX8uJCcM5N4hw7kPqQwncywHP43Mg?=
 =?us-ascii?q?YJX2id5+uwzqPs/VbhTLVLiP05jLXZvYjEKcgGpKO1GRJZ34g/5xqlETur38?=
 =?us-ascii?q?4UkHcHIV5dfRKIlYnpO1XAIPDiCve/hkyhkC91yPDaILLhGJvMLn/FkLfuZr?=
 =?us-ascii?q?t961VcxxEvwtxF+51UDbQBLOjzWk/yrNDYFAM2MxSow+b7D9VwzoceWWOJAq?=
 =?us-ascii?q?+EP6LeqESI6f40I+mNf4IVpjn9JOY/5/L0jn82h0Udfa+30psTcny4Ge5mI0?=
 =?us-ascii?q?rKKUbr19MAF3oa+xE1V+3CllKPS3hQamy0UqZ64Ss0W7irFYPSeof4uLGd0T?=
 =?us-ascii?q?3zIZpQaSgSEl2QHG33cIOLW+wGYyKRCsBkmz0AE7OmTtly+wupsVrCxqZqNK?=
 =?us-ascii?q?Lr/SsX/cb72cR4/fLUkx4a9Sd+BIKW1GTLT2IizTBAfCM/wK0q+B818VyEy6?=
 =?us-ascii?q?Ut2KQAGA=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2HVAQDLZBpelyMYgtlMGBoBAQEBAQE?=
 =?us-ascii?q?BAQEDAQEBAREBAQECAgEBAQGBaAQBAQEBCwEBGwQBgSmBTVIgEpNQgU0fg0O?=
 =?us-ascii?q?LY4EAgx4VhgcUDIFbDQEBAQEBNQIBAYRATgEXgQ8kNQgOAgMNAQEFAQEBAQE?=
 =?us-ascii?q?FBAEBAhABAQEBAQYYBoVzgh0MHgEEAQEBAQMDAwEBDAGDXQcZDzlKTAEOAVO?=
 =?us-ascii?q?DBIJLAQEznXwBjQQNDQKFHYI9BAqBCYEaI4E2AYwYGoFBP4EjIYIrCAGCAYJ?=
 =?us-ascii?q?/ARIBbIJIglkEjUISIYEHiCmYF4JBBHaJTIwCgjcBD4gBhDEDEIJFD4EJiAO?=
 =?us-ascii?q?EToF9ozdXdAGBHnEzGoImGoEgTxgNiBuOLUCBFhACT4xbgjIBAQ?=
X-IPAS-Result: =?us-ascii?q?A2HVAQDLZBpelyMYgtlMGBoBAQEBAQEBAQEDAQEBAREBA?=
 =?us-ascii?q?QECAgEBAQGBaAQBAQEBCwEBGwQBgSmBTVIgEpNQgU0fg0OLY4EAgx4VhgcUD?=
 =?us-ascii?q?IFbDQEBAQEBNQIBAYRATgEXgQ8kNQgOAgMNAQEFAQEBAQEFBAEBAhABAQEBA?=
 =?us-ascii?q?QYYBoVzgh0MHgEEAQEBAQMDAwEBDAGDXQcZDzlKTAEOAVODBIJLAQEznXwBj?=
 =?us-ascii?q?QQNDQKFHYI9BAqBCYEaI4E2AYwYGoFBP4EjIYIrCAGCAYJ/ARIBbIJIglkEj?=
 =?us-ascii?q?UISIYEHiCmYF4JBBHaJTIwCgjcBD4gBhDEDEIJFD4EJiAOEToF9ozdXdAGBH?=
 =?us-ascii?q?nEzGoImGoEgTxgNiBuOLUCBFhACT4xbgjIBAQ?=
X-IronPort-AV: E=Sophos;i="5.69,423,1571695200"; 
   d="scan'208";a="303807588"
Received: from mailrel04.vodafone.es ([217.130.24.35])
  by mail01.vodafone.es with ESMTP; 12 Jan 2020 01:17:50 +0100
Received: (qmail 8518 invoked from network); 11 Jan 2020 23:46:32 -0000
Received: from unknown (HELO 192.168.1.3) (quesosbelda@[217.217.179.17])
          (envelope-sender <peterwong@hsbc.com.hk>)
          by mailrel04.vodafone.es (qmail-ldap-1.03) with SMTP
          for <linux-scsi@vger.kernel.org>; 11 Jan 2020 23:46:32 -0000
Date:   Sun, 12 Jan 2020 00:46:30 +0100 (CET)
From:   Peter Wong <peterwong@hsbc.com.hk>
Reply-To: Peter Wong <peterwonghsbchk@gmail.com>
To:     linux-scsi@vger.kernel.org
Message-ID: <15497043.172087.1578786392229.JavaMail.cash@217.130.24.55>
Subject: Investment opportunity
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Greetings,
Please read the attached investment proposal and reply for more details.
Are you interested in loan?
Sincerely: Peter Wong




----------------------------------------------------
This email was sent by the shareware version of Postman Professional.

