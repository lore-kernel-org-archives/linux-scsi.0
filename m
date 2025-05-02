Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDED25522C
	for <linux-scsi@vger.kernel.org>; Fri,  2 May 2025 13:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746192070; cv=none; b=qiGXskirE+6VH0vw9dsNmVTZmBK/hSGr4DzqLXPkynvcdCJgUcsapdlluVTKzAEsuF8MKIxOKv3wZuAEnyVU7fbsGM+BRISKSWa7sbamq6As+7dHo6i6lJprs92bE2x67fGdcMzfr9WLI2zFE5ZXVITspH3SqcX+x7HOhEkPZjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746192070; c=relaxed/simple;
	bh=PR8rIhUfojOnm5GYJvzQzEEo4eH5EGtmUfEk+APf7Bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sP431JnVqLNOqo3CIPNXgpl3lOZtlfQ/rO0/IeDrfHHE9sWOoNGa9gW0a7NHKNxjIT5Xaq/Pyhy3nYnc1LJQHeuoldElV2EWRKLPGdQHvbJ9ZFtqRkKy1YSf4ET2IGdliDflFvQyMF5d6azweUuTUmf5ZSODYiOJt/JmxajwsF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu; spf=fail smtp.mailfrom=g.harvard.edu; dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b=fPoJ56vG; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=g.harvard.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b="fPoJ56vG"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7c9376c4dbaso239376885a.0
        for <linux-scsi@vger.kernel.org>; Fri, 02 May 2025 06:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1746192068; x=1746796868; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PR8rIhUfojOnm5GYJvzQzEEo4eH5EGtmUfEk+APf7Bc=;
        b=fPoJ56vGCB5tm6aA/wVoN195ur7xAfFtAVAJcHhVAvHutmC5nWzGdo51yvoOR4gaBS
         Omgl1s1xedvyIHByq+kAho/xukzgoFXT0XGpd5UiE2FF53xcUfs+K1Le7zQbLl4ON2vt
         jh+KeIVrls8zpksQkzXjQyJ2RxSa9KBTP1W47MOl7B/jTi7g9WEquBpOR+ZcZMbLZAud
         8liFioAwwG+8m1cRBvjc8ZTS2aZyvtebhrUvNl6+m3xpIfJ1wr+OhWY+Lt4DLVNSfGzN
         XGgXtEfW+tDT9SHfalP03sflo3zHskYes1s4znOyg3Cr4b3PvIIK2aRV8NPBmuxbrMwE
         utGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746192068; x=1746796868;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PR8rIhUfojOnm5GYJvzQzEEo4eH5EGtmUfEk+APf7Bc=;
        b=nSj60HStbxhhXQssnkFgADapHfmoe2bdPWONb8+MQ3fXrUpJ4pzhvcd6tr2wg8xzi0
         AnIN5qy7UhMwN2cABMVBxbRDD7Yl9BLZBWBC3wMMQMvIteHwKqb6tiKdDmTIATQpBxQY
         BKUfpeqnhmcrX/mESAEApyBy+Mi0DuUNcdHyNW2Dp4KOHEJBbk3RmF5J5YIMVzfBnyVp
         JSZyMEJ5cT4TQ4KP56o+PMTeowKZpO8ajYlYSycEH34zqUtukHlstuWMAGpbBNsw5IQx
         3uGhW+mfFM4ta32GJDFksBD+QtrRlUHoQZtZ39PMOMspDGZjfqYxIIR4hWInxFM6R+bI
         EAoA==
X-Forwarded-Encrypted: i=1; AJvYcCWYd1BRZwZkw2+htryN5PoWA4mfA2wMy6AhtEqHmlSqEaYs+B/jLv+DOofw6MpFiNHbZ1fhDLyFZDnf@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb3Kh/3PqXleUXx6/pSf6vfae53vSwHKIiwku38NCrYdEp9qMg
	uh7+H8cmtEHhd+BenzrL/0ak4TqVNvRiH3nNOQKcHp8sheIblG/ouyy+s3Kxfg==
X-Gm-Gg: ASbGncvtrSrWxmFHT8d54girlGL2dtSOpvo5QhUJ4z4TCgorXt9AzT3eNnHz7iozn9/
	mGiCQ0cig9N3yEEyGlM0PArCy1Dly6cxDbkgOlPIFswTEI0tz3kLGGPt4ha1YYjeRFO8dZbtchg
	nUmsRi+FBvIiJIRDb1xjUPKGa6ivdPxSGZevMB5cDvdMG39DD8WEncZDOjkMsx/9+HUrEkHpL6/
	SvQUWIkmYFPk9R6bBZmMKc6y6oUelNSbaWc+ecJxrOqNfqf2N85W2+pSY1JtbMlN3Z4Shj5QD0M
	mgoKhT+QOWdw68s6/UHWar5o2dKRWkcY6qJO4O496g==
X-Google-Smtp-Source: AGHT+IHq26iKCiiX85zd4Rzb32AF63WsqwQ34SjNsJEMCsr8I+GA+YtyhS+XJmd6yQmIzjkSHMyyXg==
X-Received: by 2002:a05:620a:c4f:b0:7ac:b95b:7107 with SMTP id af79cd13be357-7cace9a0b29mr888832585a.12.1746192067938;
        Fri, 02 May 2025 06:21:07 -0700 (PDT)
Received: from rowland.harvard.edu ([2601:19b:681:fd10::283f])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cad24413edsm181273785a.99.2025.05.02.06.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 06:21:07 -0700 (PDT)
Date: Fri, 2 May 2025 09:21:05 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/7] usb-storage: reject probe of device one non-DMA HCDs
 when using highmem
Message-ID: <b4fb1b90-1996-41ff-a05a-06f952b36ce0@rowland.harvard.edu>
References: <20250502064930.2981820-1-hch@lst.de>
 <20250502064930.2981820-5-hch@lst.de>
 <2025050258-afraid-outweigh-e36c@gregkh>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025050258-afraid-outweigh-e36c@gregkh>

On Fri, May 02, 2025 at 09:02:57AM +0200, Greg KH wrote:
> Hopefully this pushes people to use UAS devices instead :)

If usb-storage won't work on a system then UAS won't work either.

Alan Stern
