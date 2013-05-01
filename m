From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] checkpatch: Make camelcase test --strict and less noisy
Date: Wed, 1 May 2013 14:34:19 +0200
Message-ID: <20130501123419.GA29567@pd.tnic>
References: <1365544254.2946.53.camel@dabdike>
 <20130410132628.GV7511@dm>
 <1365604558.27174.36.camel@joe-AO722>
 <20130410145213.GA6854@pd.tnic>
 <1365606461.1942.3.camel@dabdike>
 <20130410151911.GG6857@pd.tnic>
 <1365691503.1929.15.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:33968 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab3EAMec (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 May 2013 08:34:32 -0400
Content-Disposition: inline
In-Reply-To: <1365691503.1929.15.camel@joe-AO722>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andy Whitcroft <apw@canonical.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Apr 11, 2013 at 07:45:03AM -0700, Joe Perches wrote:
> CamelCase tests are a bit noisy against certain
> types of code acceptable to some kernel developers.
> 
> Make the test applicable only with --strict.
> 
> Do not bleat a message on nominally acceptable
> CamelCase uses that are separated by an _ like
> drm_core_has_MTRR.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  scripts/checkpatch.pl | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 3fb6d86..97226fb 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2937,12 +2937,12 @@ sub process {
>  		while ($line =~ m{($Constant|$Lval)}g) {
>  			my $var = $1;
>  			if ($var !~ /$Constant/ &&
> -			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
> +			    $var =~ /[A-Z][a-z]|[a-z][A-Z]/ &&
>  			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
>  			    !defined $camelcase{$var}) {
>  				$camelcase{$var} = 1;
> -				WARN("CAMELCASE",
> -				     "Avoid CamelCase: <$var>\n" . $herecurr);
> +				CHK("CAMELCASE",
> +				    "Avoid CamelCase: <$var>\n" . $herecurr);

Yep, this is better.

James?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
