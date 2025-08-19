Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65673093B6;
	Tue, 19 Aug 2025 17:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755624925; cv=none; b=R2m4QB1EAC3ZE7P0Owz9c4k8cmsFgbKlg33IHxbEhsElhk5uwFSAphl28ghFAdSM3mRHN04LKKpuXsrYCwMmB+zTu38AyiiOqc93vq9nxX96+Xq0GjGO+01rcoDrvnHKHGPHT9yyg44dQJeJTtcnHbIvdE9Tltr9qBZYnF2qSao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755624925; c=relaxed/simple;
	bh=8WmBZafSgbICkwV8fKCnBbgxO2LMYVZ2kbyop77JIzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DFRrRpLILGlZmyXf8Is8InrZm+wDJAJztb/VZgXrAZuxRcWQ7JJtIxeWagnsT3f5OIyljpGwbIGr1t1LEjUy9gDKePpC6wKtwpPq5zOfAiU8LcvQmiWyeOOvk2cii+CUlPhTvJnK1Pqj6dwGG3dYr3OTOeAYFAvSApEiiD6/TbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VPKEo2jQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VPKEo2jQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB251C116D0;
	Tue, 19 Aug 2025 17:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755624925;
	bh=8WmBZafSgbICkwV8fKCnBbgxO2LMYVZ2kbyop77JIzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPKEo2jQNsBsZ86PNrJefPpUWtHqE8Gjb3i68nZ9hzfOSyOvj+KOV6hHX+0D53nUi
	 5GFXLl0Mgi9JbB9QGPely8UQ/MuzJn9SsScjmGxI1AkIrcQO/JwCClTff4nJRXQksN
	 ju5EdOw6WODz0JItEQTy7gOr5w8pzQzv/w6GLQkG4ADqjuvzIr+XpPRYunm2nap9f8
	 kebRVkHzPNuehDT3+F4/QbPoFjkFRPk+RlZfZMOE0N3u91XRFOVaYsTExIAbaq/xpj
	 wN4N7L+7QKAag9prFy06dk+1Kv1+Xq9lxAXN0foiJXYaKXsdOjypSNCGclwgIWgReU
	 crogjMOodki+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Johannes Thumshin <johannes.thumshirn@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-5.4] scsi: core: sysfs: Correct sysfs attributes access rights
Date: Tue, 19 Aug 2025 13:35:13 -0400
Message-ID: <20250819173521.1079913-3-sashal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250819173521.1079913-1-sashal@kernel.org>
References: <20250819173521.1079913-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit a2f54ff15c3bdc0132e20aae041607e2320dbd73 ]

The SCSI sysfs attributes "supported_mode" and "active_mode" do not
define a store method and thus cannot be modified.  Correct the
DEVICE_ATTR() call for these two attributes to not include S_IWUSR to
allow write access as they are read-only.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250728041700.76660-1-dlemoal@kernel.org
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Johannes Thumshin <johannes.thumshirn@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Bug Fix Nature
The commit fixes a clear bug where sysfs attributes `supported_mode` and
`active_mode` incorrectly have write permissions (S_IWUSR) despite
having no store method defined (NULL is passed as the store parameter to
DEVICE_ATTR). This is a longstanding bug dating back to 2007 when these
attributes were first introduced in commit 5dc2b89e1242.

## Security and Stability Implications
1. **Misleading permissions**: The incorrect S_IWUSR permission suggests
   these attributes are writable when they are not, which could confuse
   userspace tools and administrators.

2. **Potential crashes**: While the kernel's sysfs framework likely
   handles the NULL store method gracefully, having write permissions on
   read-only attributes is incorrect and could potentially lead to
   issues if userspace attempts to write to these files.

3. **Permission principle violation**: This violates the principle of
   least privilege - files should only have the permissions they
   actually support.

## Small and Contained Fix
The fix is extremely minimal - it simply removes the S_IWUSR flag from
two DEVICE_ATTR declarations. The changes are:
- Line 268: `S_IRUGO | S_IWUSR` → `S_IRUGO` for supported_mode
- Line 282: `S_IRUGO | S_IWUSR` → `S_IRUGO` for active_mode

## No Architectural Changes
This is a straightforward permission correction with:
- No functional changes to the SCSI subsystem
- No changes to data structures or APIs
- No new features added
- Minimal risk of regression

## Long-standing Issue
This bug has existed since 2007 (commit 5dc2b89e1242), meaning it
affects all stable kernels that include the SCSI host mode attributes.
The fact that it went unnoticed for so long suggests it's not causing
critical failures, but it's still incorrect behavior that should be
fixed.

## Stable Tree Criteria
This meets the stable tree criteria as it:
- Fixes an obvious bug (incorrect permissions)
- Is a trivial fix (2 lines changed)
- Has essentially zero risk of introducing regressions
- Corrects a violation of kernel coding standards (attributes without
  store methods should not have write permissions)

The commit is an ideal candidate for stable backporting as it's a
simple, safe correction of a longstanding permission bug in the SCSI
sysfs interface.

 drivers/scsi/scsi_sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d772258e29ad..e6464b998960 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -265,7 +265,7 @@ show_shost_supported_mode(struct device *dev, struct device_attribute *attr,
 	return show_shost_mode(supported_mode, buf);
 }
 
-static DEVICE_ATTR(supported_mode, S_IRUGO | S_IWUSR, show_shost_supported_mode, NULL);
+static DEVICE_ATTR(supported_mode, S_IRUGO, show_shost_supported_mode, NULL);
 
 static ssize_t
 show_shost_active_mode(struct device *dev,
@@ -279,7 +279,7 @@ show_shost_active_mode(struct device *dev,
 		return show_shost_mode(shost->active_mode, buf);
 }
 
-static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode, NULL);
+static DEVICE_ATTR(active_mode, S_IRUGO, show_shost_active_mode, NULL);
 
 static int check_reset_type(const char *str)
 {
-- 
2.50.1

