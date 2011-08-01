From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH v2] Fix leak in
 drivers/target/iscsi/iscsi_target_parameters.c::iscsi_copy_param_list()
Date: Mon, 1 Aug 2011 22:32:21 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1108012230080.31999@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1108010017030.28695@swampdragon.chaosbits.net> <1312152274.11635.8.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13934 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab1HAUcY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2011 16:32:24 -0400
In-Reply-To: <1312152274.11635.8.camel@Joe-Laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, 31 Jul 2011, Joe Perches wrote:

> On Mon, 2011-08-01 at 00:28 +0200, Jesper Juhl wrote:
> > We leak memory if the allocations for 'new_param->name' or 'new_param->value' fail.
> > We also do a lot of variable assignments that are completely pointless
> > if the allocations fail.
> > So, let's move the allocations before the assignments and also make
> > sure that we free whatever was allocated to one if the allocation for
> > another fails.
> 
> > diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
> []
> > +		new_param->name = kmalloc(strlen(param->name) + 1, GFP_KERNEL);
> > +		new_param->value = kmalloc(strlen(param->value) + 1, GFP_KERNEL);
> []
> >  		memcpy(new_param->name, param->name, strlen(param->name));
> >  		new_param->name[strlen(param->name)] = '\0';
> >  		memcpy(new_param->value, param->value, strlen(param->value));
> 
> kstrdup
> 
Right, now why didn't I think of that?  - thank you :)

Here's an updated version.


From: Jesper Juhl <jj@chaosbits.net>
Subject: Fix leak in drivers/target/iscsi/iscsi_target_parameters.c::iscsi_copy_param_list()

We leak memory if the allocations for 'new_param->name' or 'new_param->value' fail.
We also do a lot of variable assignments that are completely pointless
if the allocations fail.
So, let's move the allocations before the assignments and also make
sure that we free whatever was allocated to one if the allocation fail.
There's also a small CodingStyle fixup in there (curly braces on both
branches of if statement) since I was in the area anyway.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/target/iscsi/iscsi_target_parameters.c |   35 +++++++++---------------
 1 files changed, 13 insertions(+), 22 deletions(-)

  compile tested only.

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 252e246..2ab955d 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -572,6 +572,17 @@ int iscsi_copy_param_list(
 			goto err_out;
 		}
 
+		new_param->name = kstrdup(param->name, GFP_KERNEL);
+		new_param->value = kstrdup(param->value, GFP_KERNEL);
+		if (!new_param->name || !new_param->value) {
+			kfree(new_param->value);
+			kfree(new_param->name);
+			kfree(new_param);
+			pr_err("Unable to allocate memory for parameter "
+				"name/value.\n");
+			goto err_out;
+		}
+
 		new_param->set_param = param->set_param;
 		new_param->phase = param->phase;
 		new_param->scope = param->scope;
@@ -580,32 +591,12 @@ int iscsi_copy_param_list(
 		new_param->use = param->use;
 		new_param->type_range = param->type_range;
 
-		new_param->name = kzalloc(strlen(param->name) + 1, GFP_KERNEL);
-		if (!new_param->name) {
-			pr_err("Unable to allocate memory for"
-				" parameter name.\n");
-			goto err_out;
-		}
-
-		new_param->value = kzalloc(strlen(param->value) + 1,
-				GFP_KERNEL);
-		if (!new_param->value) {
-			pr_err("Unable to allocate memory for"
-				" parameter value.\n");
-			goto err_out;
-		}
-
-		memcpy(new_param->name, param->name, strlen(param->name));
-		new_param->name[strlen(param->name)] = '\0';
-		memcpy(new_param->value, param->value, strlen(param->value));
-		new_param->value[strlen(param->value)] = '\0';
-
 		list_add_tail(&new_param->p_list, &param_list->param_list);
 	}
 
-	if (!list_empty(&param_list->param_list))
+	if (!list_empty(&param_list->param_list)) {
 		*dst_param_list = param_list;
-	else {
+	} else {
 		pr_err("No parameters allocated.\n");
 		goto err_out;
 	}
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

