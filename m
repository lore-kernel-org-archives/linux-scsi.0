Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735AF190470;
	Fri,  6 Dec 2024 07:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733469591; cv=none; b=oQ43nM619xQ6s0j0dj5OkdrwKxaEctIn8FkgaLOvgk8THAtdAYMXJunjwXwUxl7D6H8l9X+RqbdGra2vfjgP9xeC8WHj+maYlz6ln5Q1C8680O8L/WCTXp5QarCCRtYYxFba6T0I2yf5L2d5UZMHYIEf848ope45lEu56kmyyvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733469591; c=relaxed/simple;
	bh=qc847rXB/emgaSDmSWzW62whsERGti559LD/d+kyWWE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=I57HsMRibQP59nf2uZi9O3Q5kzYSlqXi6TDi5bWQIdN2jjhY+gkw2IgOLdcsxcfPH07NmiWljLtfEEGIXprw/xhAAu/n9vb8fMCgLgki2J8thTl9Xsx2xoHvn0HUVgTbhqj82219slS6fPdHcMKW7jPoWfOM/ZcvzD4OuV8iqP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=N6A5MsVK; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="N6A5MsVK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=8QQoNxrQTXZNpi1Cv2dfxMHY8MZth7/afGsAC9SfYVM=;
	b=N6A5MsVKPVgQEhMEoSaf9vQEwxdI5L248rSY35bYOhx5RDMYLKbXOD2UJtV5KI
	68TzgAqdCQU0F63IDJ8BLXlGK59LsbCm5Qm9QVXjl8DLPK997bw9EbpSJ6LbE2ZE
	wuRJySFINBmWwC1iv+bBbNZXc0jhHIaY+emcx9Su0FiQY=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3PzeBpVJnjx1eBg--.45092S2;
	Fri, 06 Dec 2024 15:19:29 +0800 (CST)
From: wangdicheng <wangdich9700@163.com>
To: hare@suse.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wangdicheng <wangdicheng@kylinos.cn>,
	huanglei <huanglei@kylinos.cn>
Subject: [PATCH] scsi: aic7xxx: Fix build 'aicasm' warning
Date: Fri,  6 Dec 2024 15:19:26 +0800
Message-Id: <20241206071926.63832-1-wangdich9700@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3PzeBpVJnjx1eBg--.45092S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZr18Xr4rCFyxJFykKr1Utrb_yoW5XFyUpF
	W8C3ykAw15Jr1Uuw4ktrZ2qa45ZayktrWDJF4UZ3s29FW7WasYqF45Kay3JFy8JF10qF13
	X3Wagry7XF17A3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UNSd9UUUUU=
X-CM-SenderInfo: pzdqwv5lfkmliqq6il2tof0z/1tbioxOtT2dSigx62AABsC

From: wangdicheng <wangdicheng@kylinos.cn>

When building with CONFIG_AIC7XXX_BUILD_FIRMWARE=y or
CONFIG_AIC79XX_BUILD_FIRMWARE=y,  the warning message is as follow:

  aicasm_gram.tab.c:1722:16: warning: implicit declaration of function
    ‘yylex’ [-Wimplicit-function-declaration]

  aicasm_macro_gram.c:68:25: warning: implicit declaration of function
    ‘mmlex’ [-Wimplicit-function-declaration]

  aicasm_scan.l:417:6: warning: implicit declaration of function
    ‘mm_switch_to_buffer’

  aicasm_scan.l:418:6: warning: implicit declaration of function
    ‘mmparse’

  aicasm_scan.l:421:6: warning: implicit declaration of function
    ‘mm_delete_buffer’

The solution is to add the corresponding function declaration to the
corresponding file.

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Signed-off-by: huanglei <huanglei@kylinos.cn>
---
 drivers/scsi/aic7xxx/aicasm/aicasm_gram.y       | 1 +
 drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y | 1 +
 drivers/scsi/aic7xxx/aicasm/aicasm_scan.l       | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
index 65182ad9cdf8..b1c9ce477cbd 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
@@ -102,6 +102,7 @@ static void add_conditional(symbol_t *symbol);
 static void add_version(const char *verstring);
 static int  is_download_const(expression_t *immed);
 static int  is_location_address(symbol_t *symbol);
+int yylex();
 void yyerror(const char *string);
 
 #define SRAM_SYMNAME "SRAM_BASE"
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y b/drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y
index 8c0479865f04..5c7350eb5b5c 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y
@@ -61,6 +61,7 @@
 static symbol_t *macro_symbol;
 
 static void add_macro_arg(const char *argtext, int position);
+int mmlex();
 void mmerror(const char *string);
 
 %}
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l b/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
index c78d4f68eea5..fc7e6c58148d 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
@@ -64,6 +64,9 @@ static char *string_buf_ptr;
 static int  parren_count;
 static int  quote_count;
 static char buf[255];
+void mm_switch_to_buffer(YY_BUFFER_STATE);
+void mmparse();
+void mm_delete_buffer(YY_BUFFER_STATE);
 %}
 
 PATH		([/]*[-A-Za-z0-9_.])+
-- 
2.25.1

