From: Yu Chen <chyyuu@gmail.com>
Subject: Re: [PATCH] scsi: int overflow in st_ioctl()
Date: Wed, 18 Dec 2013 12:00:20 +0800
Message-ID: <CAAdffVH3pPpvu+GWwikPpGynTRRMW2unbyRvP2jQWpUU-=R6qw@mail.gmail.com>
References: <1387291383-25126-1-git-send-email-xuyongjiande@gmail.com>
	<F1B567DD-C322-4BA7-BFEA-E7C4B1F82697@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <F1B567DD-C322-4BA7-BFEA-E7C4B1F82697@kolumbus.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Kai_M=E4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
Cc: =?GB2312?B?0OzTwL2h?= <xuyongjiande@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Because the local variable of st_int_ioctl function, such as long ltmp
be assigned by arg.
I think  we should limit the parameter arg of st_int_ioctl function to
the range of 24-bit signed integer.
Yong Jianxu, please update your patch.

2013/12/18 "Kai M=E4kisara (Kolumbus)" <kai.makisara@kolumbus.fi>:
> On 17.12.2013, at 16.43, Yongjian Xu xuyongjiande@gmail.com wrote:
>
>> From: Yongjian Xu <xuyongjiande@gmail.com>
>>
>> mtc.mt_count comes from user-space.
>> int overflow may occur:
>> mtc.mt_count++;
>> mtc.mt_count=97;
>
> I agree that this is a problem. However, it seems that there is also =
another problem: the SPACE command uses a 24-bit count field and this o=
verflows far below INT_MAX. Should the count in MTFSF etc. be limited t=
o (2<<24-2)? This would make the checks you suggest unnecessary. (-2 so=
 that the behavior does not depend on whether we are at file mark or no=
t.)
>
> I am a bit hesitant with this suggestion because someone may use coun=
t INT_MAX to space to the end of the tape. This probably succeeds now b=
ut after the fix it would return an error.
>
> Thanks,
> Kai
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--=20
Best Regards
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Yu Chen
Ph.D.  Associate Professor
System Software&Software Engineering Group,
Dept. of Computer Science and Technology
Tsinghua University, Beijing 100084, P.R. China
E-Mail: mailto:yuchen@tsinghua.edu.cn  chyyuu@gmail.com
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
